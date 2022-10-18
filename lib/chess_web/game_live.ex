defmodule ChessWeb.GameLive do
  use ChessWeb, :live_view

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

  defp get_square_color(x, y, selected_square) do
    # TODO: Fix this shit
    if selected_square == x_y_into_chess_square(x, y) do
      "selected"
    else
      if rem(y, 2) == 0 do
        if rem(x, 2) == 0 do
          "black"
        else
          "white"
        end
      else
        if rem(x, 2) == 0 do
          "white"
        else
          "black"
        end
      end
    end
  end

  defp is_piece(x, y, pieces) do
    letter = x_y_into_chess_square(x, y)
    piece = Map.get(pieces, letter)
    piece_into_class(piece)
  end

  defp x_y_into_chess_square(x, y) do
    letter = List.to_string([64 + y])
    "#{letter}#{x}"
  end

  defp piece_into_class(nil), do: nil
  defp piece_into_class({is_black, type}) do
    "#{black_into_class(is_black)} #{type_into_class(type)}"
  end

  defp black_into_class(true), do: "black"
  defp black_into_class(false), do: "white"

  defp type_into_class("k"), do: "king"
  defp type_into_class("q"), do: "queen"
  defp type_into_class("r"), do: "rook"
  defp type_into_class("b"), do: "bishop"
  defp type_into_class("kn"), do: "knight"
  defp type_into_class("p"), do: "pawn"


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
      IO.inspect(square)
      if square == selected_square do
        selected_square == nil
      end
      {:noreply, assign(socket, :selected_square, square)}
    end

    @impl Phoenix.LiveView
    def handle_event("move_piece_to", %{"x" => x, "y" => y}, socket) do
      selected_square = socket.assigns.selected_square
      if selected_square do
        {x, _} = Integer.parse(x)
        {y, _} = Integer.parse(y)
        square = x_y_into_chess_square(x, y)
        {:noreply, handle_piece_moved(socket, "bk", square)}
      else
        {:noreply, socket}
      end
    end

    defp handle_piece_moved(
      %{assigns: %{pieces: pieces}} = socket,
      piece,
      square
    ) do
      ChessWeb.Endpoint.broadcast(socket.assigns.chess_game_topic_id, "piece_moved", %{"square" => square})
      socket
      |> put_flash(:info, "Rating submitted successfully")
      |> assign(
      :pieces,
      Map.delete(socket.assigns.pieces, socket.assigns.selected_square)
      )
    end
end
