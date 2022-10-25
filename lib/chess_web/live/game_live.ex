defmodule ChessWeb.GameLive do
  use ChessWeb, :live_view

  alias Chess.Board
  alias Chess.Piece
  alias Chess.Movement

  @impl Phoenix.LiveView
  def mount(%{"match_name" => match_name}, _session, socket) do
    board = Board.initial_status()

    match_name = String.to_atom(match_name)

    socket =
      socket
      |> assign(:match_name, match_name)
      |> assign(:board, board)
      |> assign(:turn, :white)
      |> assign(:selected_cell, nil)

    # IO.inspect(socket.assigns, label: "Board")
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "cell-click",
        %{"x" => x, "y" => y},
        %{assigns: %{selected_cell: nil}} = socket
      ) do
    IO.inspect(socket.assigns.selected_cell, label: "Selected cell")

    {:noreply,
     socket
     |> assign(selected_cell: {String.to_integer(x), String.to_integer(y)})
     |> clear_flash(:error)}
  end

  def handle_event("cell-click", %{"x" => x, "y" => y}, socket) do
    target_x = String.to_integer(x)
    target_y = String.to_integer(y)
    {piece_x, piece_y} = socket.assigns.selected_cell

    socket =
      case Board.find_piece(socket.assigns.board, piece_x, piece_y) do
        nil -> socket
        piece -> move(socket, piece, {piece_x, piece_y}, {target_x, target_y})
      end

    {:noreply, assign(socket, selected_cell: nil)}
  end

  def handle_event("cell-click", coords, socket) do
    IO.inspect(coords, label: "Event coords")
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section>
      <div class="board">
      <%= for x <- 7..0 do %>
        <%= for y <- 0..7 do %>
          <.cell x={y}
                  y={x}
                  piece={get_piece(@board, y, x)}
                  selected={@selected_cell == {y,x}}
                  color={if rem(x + y, 2) == 1, do: "white", else: "black"}/>

        <% end %>
      <% end %>
      </div>
    </section>
    """
  end

  defp cell(assigns) do
    ~H"""
      <div id={"cell-#{@x}-#{@y}"}
           class={"square #{@color} #{if @selected, do: "selected"}"}
           phx-click="cell-click"
           phx-value-x={@x}
           phx-value-y={@y}>
        <%= if @piece do %>
          <div class={"figure #{@piece.color} #{@piece.type}"}></div>
        <% end %>
        <!--<small><%= @x %>, <%= @y %></small>-->
      </div>
    """
  end

  defp get_piece(board, x, y), do: board[x][y]

  defp move(socket, piece, {piece_x, piece_y} = origin, {target_x, target_y} = target) do
    IO.inspect(piece, label: "Piece")
    IO.puts("Moving piece from x: #{piece_x}, y: #{piece_y} to x:#{target_x}, y:#{target_y}")
    board = socket.assigns.board

    with false <- Board.target_out_of_board?(target),
         {:ok, board} <- Board.move(board, piece, origin, target) do
      socket
      |> assign(board: board)
      |> assign(turn: next_turn(socket.assigns.turn))
    else
      _ ->
        put_flash(socket, :error, "This move is not valid.")

      nil ->
        socket
    end
  end

  defp next_turn(:white), do: :black
  defp next_turn(:black), do: :white
end
