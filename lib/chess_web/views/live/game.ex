defmodule ChessWeb.GameLive do
  use ChessWeb, :live_view

  alias Chess.Dashboard
  alias Chess.Game
  alias Chess.Movement

  def mount(%{"uid" => game_id}, %{"user" => user} = session, socket) do
    game_agent = Game.get_game(game_id, user)
    board = Game.get_board(game_agent)
    turn_of = Game.get_turn_of(game_agent)
    players = Game.get(game_agent, :players)

    {my_role, player} = get_role_player(players, user, game_agent)

    if connected?(socket) do
      # subscribe to board update events
      Game.subscribe(game_agent)
    end

    socket =
      socket
      |> assign(:board, board)
      |> assign(:session, session)
      |> assign(:user, user)
      |> assign(:game_agent, game_agent)
      |> assign(:focus, nil)
      |> assign(:movements, [])
      |> assign(:checkmate, false)
      |> assign(:winner, nil)
      |> assign(:turn_of, turn_of)
      |> assign(:role, my_role)
      |> assign(:player, player)

    socket =
      if Movement.checkmate?(board, turn_of) do
        winner = if turn_of == :white, do: :black, else: :white
        socket = socket |> assign(:checkmate, true) |> assign(:winner, winner)
        Game.set_winner(game_agent, winner)
        socket
      else
        socket
      end

    {:ok, socket}
  end

  def mount(%{"uid" => game_id}, _session, socket) do
    # no user session... first set a session by redirecting to PageController
    socket = redirect(socket, to: Routes.page_path(ChessWeb.Endpoint, :new_user, game_id))
    {:ok, socket}
  end

  def handle_info(:new_board, socket) do
    socket = load(socket)
    {:noreply, socket}
  end

  def handle_event("square-click", _, %{assigns: %{role: :specter}} = socket),
    do: {:noreply, socket}

  def handle_event("square-click", %{"position" => pos_str}, socket) do
    game_agent = socket.assigns.game_agent
    player = socket.assigns.player
    turn_of = Game.get_turn_of(game_agent)

    if player == turn_of do
      handle_click(pos_str, socket)
    else
      {:noreply, socket}
    end
  end

  defp handle_click(pos_str, socket) do
    clicked_pos = deserialize_pos(pos_str)
    focus = old_pos = socket.assigns.focus
    board = socket.assigns.board
    game_agent = socket.assigns.game_agent
    moves = socket.assigns.movements
    turn_of = Game.get_turn_of(game_agent)

    case click_action(board, focus, clicked_pos, turn_of, moves) do
      :focus ->
        socket =
          socket
          |> assign(:focus, clicked_pos)
          |> assign(:movements, Movement.possible_movements(board, clicked_pos))

        {:noreply, socket}

      :move ->
        piece = Dashboard.get(board, old_pos)
        new_board = Dashboard.move(board, piece, clicked_pos, old_pos)

        Game.next_turn(game_agent)
        Game.set_board(game_agent, new_board)
        current_turn_of = Game.get_turn_of(game_agent)

        socket =
          socket
          |> assign(:board, new_board)
          |> assign(:focus, nil)
          |> assign(:movements, [])
          |> assign(:turn_of, current_turn_of)

        if Movement.checkmate?(new_board, current_turn_of) do
          socket = socket |> assign(:checkmate, true) |> assign(:winner, turn_of)
          Game.set_winner(game_agent, turn_of)
          {:noreply, socket}
        else
          {:noreply, socket}
        end

      _ ->
        {:noreply, socket}
    end
  end

  defp click_action(board, focus, clicked_pos, player, moves)

  defp click_action(board, nil, clicked_pos, player, _moves) do
    case Dashboard.get(board, clicked_pos) do
      %{color: ^player} -> :focus
      _ -> :none
    end
  end

  defp click_action(board, _focus, clicked_pos, player, moves) do
    case Dashboard.get(board, clicked_pos) do
      %{color: ^player} ->
        :focus

      nil ->
        if Enum.member?(moves, clicked_pos) do
          :move
        else
          :none
        end

      _piece_other_player ->
        :move
    end
  end

  defp deserialize_pos(pos) do
    [x, y] = pos |> String.split("-") |> Enum.map(&String.to_integer/1)
    {x, y}
  end

  defp get_role_player(players, user, game_agent) do
    case players do
      %{white: ^user} ->
        {:player, :white}

      %{black: ^user} ->
        {:player, :black}

      %{black: nil} ->
        Game.set(game_agent, :players, Map.put(players, :black, user))
        {:player, :black}

      _ ->
        {:specter, nil}
    end
  end

  defp load(socket) do
    game_agent = socket.assigns.game_agent
    board = Game.get_board(game_agent)
    turn_of = Game.get_turn_of(game_agent)

    socket =
      socket
      |> assign(:board, board)
      |> assign(:turn_of, turn_of)

    if Movement.checkmate?(board, turn_of) do
      winner = if turn_of == :white, do: :black, else: :white
      socket |> assign(:checkmate, true) |> assign(:winner, winner)
    else
      socket
    end
  end
end
