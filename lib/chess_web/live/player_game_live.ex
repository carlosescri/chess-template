defmodule ChessWeb.PlayerGameLive do

  use ChessWeb, :live_view

  alias Chess.Game
  alias Chess.GameServer

  def mount(%{"id" => id}, _session, socket) do
    game_name = String.to_atom(id)
    socket = assign(socket, :game_name, game_name)
    GameServer.start_link(socket.assigns.game_name)
    socket =
      socket
      |> assign(game_state: Game.new())
      |> assign(selected_figure: nil)
      |> assign(selected_cell: {0,0})
      |> assign(available_moves: [])
      |> assign(allow: false)

    if connected?(socket) do
      case GameServer.join(socket.assigns.game_name) do
        {:ok, game_state, player} ->
          socket =
            socket
            |> assign(game_state: game_state)
            |> assign(player: player)
            |> assign(allow: true)
          {:ok, socket}
        {:spectator, game_state} ->
          {:ok, assign(socket, player: :view_mode, allow: true, game_state: game_state)}
      end
    else
      {:ok, socket}
    end
  end

  def handle_event("select", _params, %{assigns: %{player: :white, game_state: %{turn: :black}}} = socket) do
    {:noreply, socket}
  end

  def handle_event("select", _params, %{assigns: %{player: :black, game_state: %{turn: :white}}} = socket) do
    {:noreply, socket}
  end

  def handle_event("select", _params, %{assigns: %{player: :view_mode}} = socket) do
    {:noreply, socket}
  end

  def handle_event("select", %{"column" => column, "row" => row}, %{assigns: %{selected_cell: {0,0}}} = socket )do
    row = String.to_integer(row)
    column = String.to_integer(column)

    selected_figure = get_figure(row, column, socket.assigns.game_state) |> List.first()

    available_moves = Game.get_availables_moves(socket.assigns.game_state, selected_figure) |> IO.inspect()

    cond do
      is_nil(selected_figure) -> {:noreply, socket}
      selected_figure.player == socket.assigns.player ->
        {:noreply, socket
        |> assign(selected_cell: {row, column})
        |> assign(available_moves: available_moves)
        |> assign(selected_figure: selected_figure)}
      true  -> {:noreply, socket}
      end
    end

  def handle_event("select", %{"column" => column, "row" => row}, socket )do
    row = String.to_integer(row)
    column = String.to_integer(column)

    {:ok, new_state} = GameServer.move(socket.assigns.game_name, socket.assigns.selected_figure, {row, column})
    # MOVE
    {:noreply, assign(socket, selected_cell: {0, 0}, selected_figure: nil, game_state: new_state, available_moves: [])}
  end

  def handle_info(new_state, socket) do
    {:noreply, assign(socket, game_state: new_state)}
  end


  def get_figure(row, column, game_state) do
    figure = Enum.find(game_state.figures, fn %Chess.Figures{position: {figure_row, figure_column}} -> {figure_row, figure_column} == {row, column} end)
    if figure do
      [figure]
    else
      []
    end
  end

  def square_color(row, column) do
    if rem(row + column, 2) == 0 do
      "white"
    else
      "black"
    end
  end
end
