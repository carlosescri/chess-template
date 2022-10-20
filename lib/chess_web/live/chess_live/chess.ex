defmodule ChessWeb.ChessLive.Chess do
  # use Phoenix.LiveView, layout: {ChessWeb.PageView, "index.html"}
  alias Chess.Games
  alias Chess.Games.GameServer

  use Phoenix.LiveView


  def mount(%{"game_name"=> game_name}, _session, socket) do
    game_name_atom = String.to_atom(game_name)
    game = Games.new(game_name_atom)
    GameServer.start_link(game_name_atom)

    {:ok, assign(socket, game: game, selected_piece: nil)}
  end

  def handle_event(
        "select-piece",
        %{"y" => y_coordinate, "x" => x_coordinate},
        %{assigns: %{selected_piece: nil}} = socket
      ) do
    {:noreply,
     assign(socket,
       selected_piece: {String.to_integer(x_coordinate), String.to_integer(y_coordinate)}
     )}
  end

  def handle_event("select-piece", %{"y" => y_coordinate, "x" => x_coordinate}, socket) do
    new_coordinates_piece = {String.to_integer(x_coordinate), String.to_integer(y_coordinate)}
    value_selected_piece = socket.assigns.game.dashboard[socket.assigns.selected_piece]

    case value_selected_piece do
      nil ->
        {:noreply, socket}

      _ ->
        # ea = Games.execute_move(socket.assigns.game, socket.assigns.selected_piece, new_coordinates_piece)
        updated_dashboard =
          socket.assigns.game.dashboard
          |> Map.put(new_coordinates_piece, value_selected_piece)
          |> Map.put(socket.assigns.selected_piece, nil)

        updated_game = Map.put(socket.assigns.game, :dashboard, updated_dashboard)
        {:noreply, assign(socket, game: updated_game, selected_piece: nil)}
    end
  end

  def handle_event("join-player", %{}, socket) do
    {:ok, new_state} = GameServer.join_player(socket.assigns.game.game_name)

    {:noreply, assign(socket, game: new_state)}
  end
end
