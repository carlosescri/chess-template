defmodule ChessWeb.GameLive do
  use ChessWeb, :live_view

  alias ChessWeb.BoardLive

  @chess_game_topic "chess_game"


  @impl Phoenix.LiveView
  def mount(%{"game_name" => game_name}, _session, socket) do
    topic_name = "#{@chess_game_topic}-#{game_name}"
    if connected?(socket) do
      ChessWeb.Endpoint.subscribe(topic_name)
    end

    {:ok,
    socket
    |> assign(:game_name, nil)
    |> assign(:chess_game_topic_id, topic_name)
    |> assign_initial_position()}
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
    pieces = Map.delete(socket.assigns.pieces, square)
    send_update(
      BoardLive,
      id: socket.assigns.chess_game_topic_id,
      pieces: pieces)
    {:noreply, assign(socket, :pieces, pieces)}
    end

  defp assign_initial_position(socket) do
    initial_position = %{
      "A1" => {false, "r"},
      "A2" => {false, "kn"},
      "A3" => {false, "b"},
      "A4" => {false, "q"},
      "A5" => {false, "k"},
      "A6" => {false, "b"},
      "A7" => {false, "kn"},
      "A8" => {false, "r"},
      "B1" => {false, "p"},
      "B2" => {false, "p"},
      "B3" => {false, "p"},
      "B4" => {false, "p"},
      "B5" => {false, "p"},
      "B6" => {false, "p"},
      "B7" => {false, "p"},
      "B8" => {false, "p"},
      "H1" => {true, "r"},
      "H2" => {true, "kn"},
      "H3" => {true, "b"},
      "H4" => {true, "q"},
      "H5" => {true, "k"},
      "H6" => {true, "b"},
      "H7" => {true, "kn"},
      "H8" => {true, "r"},
      "G1" => {true, "p"},
      "G2" => {true, "p"},
      "G3" => {true, "p"},
      "G4" => {true, "p"},
      "G5" => {true, "p"},
      "G6" => {true, "p"},
      "G7" => {true, "p"},
      "G8" => {true, "p"},
    }
    assign(socket, :pieces, initial_position)
  end
end
