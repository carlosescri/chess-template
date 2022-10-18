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

        Games.add_player(game_id, user)
        game = Games.get_game(game_id)

        Games.subscribe(game_id)

        {
          :ok,
          socket
          |> assign(:connected, true)
          |> assign(:game_id, game_id)
          |> assign(:board, Map.get(game, :board))
          |> assign(:is_leader, Map.get(game, :leader))
          |> assign(:turn, Map.get(game, :turn))
          |> assign(:user, user)
          |> assign(:selected, nil)
          |> assign(:status, Map.get(game, :status))
          |> assign(:players, Map.get(game, :players) |> MapSet.to_list())
          |> assign(:figures, (if Map.get(game, :leader) == user, do: :whites, else: :blacks))
        }
    else
      {
        :ok,
        assign(socket, :connected, false)
      }
    end
  end

  def show_start_button(true, :ready), do: true

  def show_start_button(_, _), do: false



 def handle_info({"update_board", board}, socket) do
    {
      :noreply,
      assign(socket, board: board)
    }
  end

  def handle_info({"player_connected", game}, socket) do
    {
      :noreply,
      socket
      |> assign(:status, Map.get(game, :status))
      |> assign(:players, game |> Map.get(:players) |> MapSet.to_list())
      |> assign(:is_leader, Map.get(game, :leader) == socket.assigns.user)
    }
  end

  def handle_info({"start_game", new_state}, socket) do
    {
      :noreply,
      socket
      |> assign(status: Map.get(new_state, :status))
      |> assign(turn: Map.get(new_state, :turn))
      |> assign(:figures, (if Map.get(new_state, :leader) == socket.assigns.user, do: :whites, else: :black))
    }
  end

  def handle_event("move", _value, socket) do
    IO.puts("Move figure")

    new_board = Games.move_figure(socket.assigns.game_id, socket.assigns.user, {0,0}, {5,4})

    {:noreply, assign(socket, board: new_board)}
  end

  def handle_event("start_game", _, socket) do
    Games.start_game(socket.assigns.game_id)
    {:noreply, socket}
  end

  def handle_event("click_square", %{"row" => row, "col" => col}, %{assigns: %{selected: nil}} = socket) do
    IO.puts("Square {#{row},#{col}} was clicked")

    clicked_row = String.to_integer(row)
    clicked_col = String.to_integer(col)

    {:noreply, assign(socket, selected: {clicked_row, clicked_col})}
  end

  def handle_event("click_square", %{"row" => row, "col" => col}, %{assigns: %{selected: selected_square}} = socket) do
    IO.puts("Square {#{row},#{col}} was clicked, move figure now!")

    clicked_row = String.to_integer(row)
    clicked_col = String.to_integer(col)

    Games.move_figure(socket.assigns.game_id, socket.assigns.user, selected_square, {clicked_row, clicked_col})

    {
      :noreply,
      socket
      |> assign(selected: nil)
    }
  end



end
