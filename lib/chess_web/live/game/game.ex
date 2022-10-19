defmodule ChessWeb.GameLive.Game do
  use ChessWeb, :live_view

  alias Chess.Game
  alias Chess.GameServer
  alias ChessWeb.Components

  require Logger

  def mount(%{"id" => game_id}, %{"username" => user}, socket) do
    if connected?(socket) do
      Logger.info("Joining game: #{game_id}")

      game = GameServer.connect(game_id, user)
      GameServer.subscribe(game_id)

      {
        :ok,
        socket
        |> assign(:connected, true)
        |> assign(:game_id, game_id)
        |> assign(:game, game)
        |> assign(:game_mode, Game.get_player_mode(game, user))
        |> assign(:user, user)
        |> assign(:selected, nil)
        |> assign(:players, MapSet.to_list(game.players))
        |> assign(:figures, Game.get_player_figures(game, user))
      }
    else
      {
        :ok,
        assign(socket, :connected, false)
      }
    end
  end

  def show_start_button(:master, :ready), do: true

  def show_start_button(_, _), do: false

  def handle_info({"update_board", game}, socket) do
    {
      :noreply,
      socket
      |> assign(board: game.board)
      |> assign(game: game)
    }
  end

  def handle_info({"player_connected", game}, socket) do
    {
      :noreply,
      socket
      |> assign(:game, game)
      |> assign(:players, MapSet.to_list(game.players))
      |> assign(:is_leader, Map.get(game, :leader) == socket.assigns.user)
    }
  end

  def handle_info({"start_game", game}, socket) do
    {
      :noreply,
      socket
      |> assign(:game, game)
    }
  end

  def handle_event("start_game", _, socket) do
    GameServer.start_game(socket.assigns.game_id)
    {:noreply, socket}
  end

  def handle_event(
        "click_square",
        %{"row" => row, "col" => col},
        %{assigns: %{selected: nil}} = socket
      ) do
    clicked_row = String.to_integer(row)
    clicked_col = String.to_integer(col)

    case Game.select_figure(socket.assigns.game, {clicked_row, clicked_col}) do
      :ok -> {:noreply, assign(socket, selected: {clicked_row, clicked_col})}
      :error -> {:noreply, assign(socket, selected: nil)}
    end
  end

  def handle_event(
        "click_square",
        %{"row" => row, "col" => col},
        %{assigns: %{selected: selected_square}} = socket
      ) do
    IO.puts("Square {#{row},#{col}} was clicked, move figure now!")

    clicked_row = String.to_integer(row)
    clicked_col = String.to_integer(col)

    GameServer.move_figure(
      socket.assigns.game_id,
      socket.assigns.user,
      selected_square,
      {clicked_row, clicked_col}
    )

    {
      :noreply,
      socket
      |> assign(selected: nil)
    }
  end
end
