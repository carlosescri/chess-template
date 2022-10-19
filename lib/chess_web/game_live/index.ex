defmodule ChessWeb.BoardLive.Index do
  use ChessWeb, :live_view

  alias Chess.Board
  alias Chess.Movement

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {pieces, squares} = Board.init()

    socket = socket
      |> assign(:pieces, pieces)
      |> assign(:squares, squares)
      |> assign(:square_selected, nil)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event(square_id, _params, socket) do
    if socket.assigns.square_selected do
      squares = case Movement.move(socket.assigns.pieces, socket.assigns.squares, socket.assigns.square_selected, square_id) do
        {:ok, squares} ->
          IO.inspect("ok")
          squares
        {_, squares} ->
          IO.inspect("not valid")
          squares
      end

      socket = socket
      |> assign(:square_selected, nil)
      |> assign(:squares, squares)

      {:noreply, socket}
    else
      {int_square_id, _} = Integer.parse(square_id)
      square = Board.get_square(socket.assigns.squares, int_square_id)

      if square.chesspiece_id do
        {:noreply, assign(socket, :square_selected, square_id)}
      else
        {:noreply, socket}
      end
    end
  end
end
