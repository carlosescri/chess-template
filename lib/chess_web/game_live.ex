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

    socket =
      if connected?(socket) do
        result = GameAgent.join_to_game(game, session)
        add_flash_message(socket, result)
      else
        socket
      end

    {:ok, socket |> assign(:game, game)}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("click:square", %{"square" => _square}, socket) do
    # is first click or second click?
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

  defp add_flash_message(socket, :white_joined) do
    put_flash(socket, :info, "Joined to the game as a player! You play as white")
  end

  defp add_flash_message(socket, :black_joined) do
    put_flash(socket, :info, "Joined to the game as a player! You play as black")
  end

  defp add_flash_message(socket, :spectator_joined) do
    put_flash(socket, :info, "Joined to the game as a viewer. Enjoy!")
  end

  defp add_flash_message(socket, nil), do: socket
end
