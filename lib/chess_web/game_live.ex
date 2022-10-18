defmodule ChessWeb.GameLive do
  use ChessWeb, :live_view

  alias ChessWeb.BoardLive
  alias ChessWeb.GameServer

  @chess_game_topic "chess_game"


  @impl Phoenix.LiveView
  def mount(%{"game_name" => game_name}, _session, socket) do
    pid = Process.whereis(GameServer)
    pieces = GameServer.get_pieces(pid)
    topic_name = "#{@chess_game_topic}-#{game_name}"
    if connected?(socket) do
      ChessWeb.Endpoint.subscribe(topic_name)
    end

    {:ok,
    socket
    |> assign(:game_name, nil)
    |> assign(:chess_game_topic_id, topic_name)
    |> assign(:pid, pid)
    |> assign(:selected_square, nil)
    |> assign_pieces()}
  end

  @impl Phoenix.LiveView
  @spec handle_params(%{:game_name => binary()}, any, map) :: {:noreply, map}
  def handle_params(%{"game_name" => game_name}, _uri, socket) do
    {
      :noreply,
      socket
      |> assign(:game_name, game_name)
    }
  end

  def handle_info(%{event: "piece_moved", payload: %{"square" => square}}, socket) do
    old_square = socket.assigns.selected_square
    if old_square do
      pieces = Map.delete(socket.assigns.pieces, square)
      GameServer.move_piece(socket.assigns.pid, %{"old_square" => old_square, "new_square" => square})
      {:noreply,
        socket
        |> assign(:pieces, pieces)
        |> assign(:selected_square, nil)}
    else
      {:noreply,
      socket
      |> assign(:selected_square, square)}
    end
  end

  defp assign_pieces(socket) do
    pieces = GameServer.get_pieces(socket.assigns.pid)
    assign(socket, :pieces, pieces)
  end
end
