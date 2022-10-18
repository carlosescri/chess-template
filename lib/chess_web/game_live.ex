defmodule ChessWeb.GameLive do
  use ChessWeb, :live_view

  import Chess.Board

  alias ChessWeb.BoardLive
  alias ChessWeb.GameServer
  alias ChessWeb.BoardLive.Components

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

  def handle_info(%{event: "piece_moved"}, socket) do
    {:noreply,
      socket
      |> assign_pieces()
      |> assign(:selected_square, nil)}
  end

  defp assign_pieces(socket) do
    pieces = GameServer.get_pieces(socket.assigns.pid)
    assign(socket, :pieces, pieces)
  end

  # Board

  defp board(assigns) do
    assigns = assign_new(assigns, :selected_square, fn -> nil end)

    ~H"""
    <section>
      <div class="board">
        <%= for y <- 8..1 do %>
          <%= for x <- 1..8 do %>
            <div class={"square #{get_square_color(x, y, @selected_square)}"} id={"#{x}#{y}"}
              phx-click="move_piece_to"
              phx-value-x={x}
              phx-value-y={y}
            >
              <%= if is_piece(x, y, @pieces) do %>
                <div class={"figure #{is_piece(x, y, @pieces)}"}
                  phx-click="move_piece_from"
                  phx-value-x={x}
                  phx-value-y={y}
            />
              <% end %>
            </div>
          <% end %>
        <% end %>
      </div>
    </section>
    """
  end

  def update(assigns, socket) do
    {:ok,
    socket
    |> assign(:chess_game_topic_id, assigns.id)
    |> assign(:pieces, assigns.pieces)
    |> assign(:selected_square, nil)}
    end

    @impl Phoenix.LiveView
    def handle_event("move_piece_from", %{"x" => x, "y" => y}, socket) do
      {x, _} = Integer.parse(x)
      {y, _} = Integer.parse(y)
      square = x_y_into_chess_square(x, y)
      selected_square = socket.assigns.selected_square
      if square == selected_square do
        selected_square == nil
      end
      {:noreply, assign(socket, :selected_square, square)}
    end

    @impl Phoenix.LiveView
    def handle_event("move_piece_to", _, %{assigns: %{selected_square: nil}} = socket), do: {:noreply, socket}

    def handle_event(
      "move_piece_to",
      %{"x" => x, "y" => y},
      %{assigns: %{selected_square: selected_square}} = socket) do
      {x, _} = Integer.parse(x)
      {y, _} = Integer.parse(y)
      square = x_y_into_chess_square(x, y)
      GameServer.move_piece(socket.assigns.pid, %{"old_square" => selected_square, "new_square" => square})
      {:noreply, handle_piece_moved(socket, square)}
    end

    def handle_piece_moved(
      %{assigns: %{pieces: pieces, selected_square: selected_square}} = socket,
      square
    ) do
      ChessWeb.Endpoint.broadcast(socket.assigns.chess_game_topic_id, "piece_moved", %{})
      socket
      |> put_flash(:info, "Movement submitted successfully")
      |> assign(
      :pieces,
      Map.delete(socket.assigns.pieces, selected_square))
      |> assign(:selected_square, nil)
    end
end
