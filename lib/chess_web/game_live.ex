defmodule ChessWeb.GameLive do
  @moduledoc """
  Live view for a game
  """

  use ChessWeb, :live_view

  alias ChessWeb.GameAgent
  alias ChessWeb.Board

  @impl Phoenix.LiveView
  def mount(%{"game" => game}, session, socket) do
    game = String.to_atom(game)
    start_game(game)

    socket = join_game(socket, game, session)
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event(_event, _params, %{assigns: %{role: role}} = socket)
      when role not in [:white, :black] do
    {:noreply, put_flash(socket, :error, "Can't play as a viewer")}
  end

  def handle_event(
        "click:square",
        %{"square" => square},
        %{assigns: %{first_square_clicked: nil}} = socket
      ) do
    socket =
      socket
      |> highlight_clicked_square(square)
      |> assign(:first_square_clicked, square)

    {:noreply, socket}
  end

  def handle_event(
        "click:square",
        %{"square" => square},
        %{assigns: %{first_square_clicked: first_square_clicked}} = socket
      ) do
    socket =
      socket
      |> remove_highlight_from_square(first_square_clicked)
      |> highlight_clicked_square(square)
      |> assign(:first_square_clicked, square)

    {:noreply, socket}
  end

  def handle_event("click:square", %{"square" => _square}, socket) do
    {:noreply, socket}
  end

  defp start_game(game) do
    initial_state = %{
      board: Board.starting_board(),
      game: game,
      people_joined: 0,
      players: %{white: nil, black: nil},
      turn_of: :white
    }

    GameAgent.start_link(initial_state)
  end

  defp remove_highlight_from_square(%{assigns: %{board: board}} = socket, square) do
    assign(socket, :board, Board.remove_highlight_from_square(board, square))
  end

  defp highlight_clicked_square(%{assigns: %{board: board}} = socket, square) do
    assign(socket, :board, Board.highlight_square(board, square))
  end

  defp join_game(socket, game, session) do
    socket = default_assigns(socket, game)

    socket =
      if connected?(socket) do
        who_joined = GameAgent.join_to_game(game, session)

        socket
        |> add_flash_message(who_joined)
        |> add_game_role(who_joined)
        |> load_board()
      else
        socket
      end

    socket
  end

  defp default_assigns(socket, game) do
    socket
    |> assign(:game, game)
    |> assign_new(:role, fn -> nil end)
    |> assign_new(:first_square_clicked, fn -> nil end)
    |> assign_new(:board, fn -> %{} end)
  end

  defp load_board(socket) do
    assign(socket, :board, GameAgent.get_board(socket.assigns.game))
  end

  defp add_game_role(socket, who_joined) when who_joined in [:white, :black, :viewer] do
    assign(socket, :role, who_joined)
  end

  defp add_game_role(socket, nil), do: assign(socket, :role, :white)

  defp add_flash_message(socket, who_joined) do
    messages = %{
      white: "Joined to the game as a player! You play as white",
      black: "Joined to the game as a player! You play as black",
      viewer: "Joined to the game as a viewer. Enjoy!"
    }

    message = Map.get(messages, who_joined)

    if message do
      put_flash(socket, :info, message)
    else
      socket
    end
  end
end
