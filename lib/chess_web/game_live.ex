defmodule ChessWeb.GameLive do
  @moduledoc """
  Live view for a game
  """

  use ChessWeb, :live_view

  alias ChessWeb.GameAgent
  alias ChessWeb.Board

  @impl Phoenix.LiveView
  def mount(%{"game_id" => game_id}, _session, socket) do
    game_id = String.to_atom(game_id)
    initial_state = %{
      board: Board.starting_board(),
      game_id: game_id,
      second_player_joined: false,
      turn_of: :white
    }

    children = [
      %{
        id: GameAgent,
        start: {GameAgent, :start_link, [initial_state]}
      }
    ]
    Supervisor.start_link(children, strategy: :one_for_all)

    socket = assign(socket, :game_id, game_id)

    GameAgent
    {:ok, socket}
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
end
