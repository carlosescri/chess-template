defmodule ChessWeb.GameLive.Game do
  use ChessWeb, :live_view

  alias Chess.Game.Board
  alias Chess.Game.Figure
  alias Chess.Games
  alias ChessWeb.Components

  require Logger

  def mount(%{"id" => game_id}, %{"username" => user}, socket) do

    if connected?(socket) do
        Logger.info("Joining game: #{game_id}")
        Games.subscribe(game_id)

        {
          :ok,
          socket
          |> assign(:connected, true)
          |> assign(:game_id, game_id)
          |> assign(:board, Games.get_board(game_id))
          |> assign(:user, user)
          |> assign(:current_players, Games.get_current_players(game_id))
        }
    else
      {
        :ok,
        assign(socket, :connected, false)
      }
    end


  end

  def handle_event("move", _value, socket) do
    IO.puts("Move figure")

    new_board = Games.move_figure(socket.assigns.game_id, socket.assigns.user, {0,0}, {5,4})

    {:noreply, assign(socket, board: new_board)}
  end

 def handle_info({"update_board", board}, socket) do
    {
      :noreply,
      assign(socket, board: board)
    }
  end
end
