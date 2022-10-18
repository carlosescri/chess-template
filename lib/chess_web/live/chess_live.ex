defmodule ChessWeb.ChessLive do
  # use Phoenix.LiveView, layout: {ChessWeb.PageView, "index.html"}
  alias Chess.Games
  use Phoenix.LiveView

  # def new(game_name) do
  #   %Game{game_name: game_name, start_date: NaiveDateTime.utc_now}
  # end

  def mount(_params, _session, socket) do
    game = Games.new()
    {:ok, assign(socket, game: game, selected_piece: nil)}
  end

  def handle_event("select-piece", %{"y" => y_coordinate, "x" => x_coordinate}, %{assigns: %{selected_piece: nil}}=socket) do
    {:noreply, assign(socket, selected_piece: {String.to_integer(x_coordinate), String.to_integer(y_coordinate)})}
  end

  def handle_event("select-piece", %{"y" => y_coordinate, "x" => x_coordinate}, socket) do
    new_coordinates_piece = {String.to_integer(x_coordinate), String.to_integer(y_coordinate)}
    value_selected_piece = socket.assigns.game.dashboard[socket.assigns.selected_piece]
    updated_dashboard =
      socket.assigns.game.dashboard
      |> Map.put(new_coordinates_piece, value_selected_piece)
      |> Map.put(socket.assigns.selected_piece, nil)

    updated_game = Map.put(socket.assigns.game, :dashboard, updated_dashboard)
    {:noreply, assign(socket, game: updated_game, selected_piece: nil)}
  end

end
