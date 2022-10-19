defmodule ChessWeb.ChessLive do
  use Phoenix.LiveView, layout: {ChessWeb.LayoutView, "live.html"}

  alias Chess.Board

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:board, Board.get_positions())
     |> assign(:tmp_square, nil)}
  end

  def handle_event("select-square", %{"row" => row, "column" => column}, socket) do
    position = {String.to_integer(column), String.to_integer(row)}

    case Map.get(socket.assigns, :tmp_square) do
      nil ->
        {:noreply, assign(socket, :tmp_square, position)}

      tmp_square ->
        board =
          Board.move(
            socket.assigns.board,
            tmp_square,
            position
          )

        {:noreply, assign(socket, board: board, tmp_square: nil)}
    end
  end
end
