defmodule BoardComponent do
  use Phoenix.Component

  def draw(assigns) do
    ~H"""
    <div>

    <section>
      <div class="board">
        <%= for {piece, position, square_color} <- iter_board(@board) do %>
          <BoardComponent.draw_piece
          movements={@movements}
          focus={@focus}
          piece={piece}
          position={position}
          square_color={square_color}/>
        <% end %>
      </div>
    </section>
    </div>
    """
  end

  def draw_piece(
        %{piece: nil, position: pos, square_color: square_color, movements: moves} = assigns
      ) do
    focus? = Enum.member?(moves, pos)

    ~H"""
    <div
      phx-click="square-click"
      phx-value-position={serialize(pos)}
      class={"square #{square_color}"}>
        <div class={"emptyfocus " <> set_focus(focus?)}></div>
    </div>
    """
  end

  def draw_piece(
        %{
          piece: %{type: type, color: color},
          position: pos,
          square_color: square_color,
          focus: focus,
          movements: moves
        } = assigns
      ) do
    focus? = Enum.member?(moves, pos)

    ~H"""
    <div
      phx-click="square-click"
      phx-value-position={serialize(pos)}
      class={"square #{square_color}"}>
        <div class={"figure #{type} #{color} #{set_focus(focus?)} #{set_focus(focus, pos)}"}></div>
      </div>
    """
  end

  defp set_focus(true), do: "focus"
  defp set_focus(_), do: ""

  defp set_focus(my_pos, focus_pos) when my_pos == focus_pos, do: "focus"
  defp set_focus(_my_pos, _focus_pos), do: ""

  defp iter_board(board) do
    board
    |> Enum.with_index()
    |> Enum.flat_map(fn {column, x} ->
      column
      |> Enum.with_index()
      |> Enum.map(fn {piece, y} ->
        mod = :math.fmod(x + y, 2)
        square_color = if mod == 1.0, do: "white", else: "black"
        position = {x, y}
        {piece, position, square_color}
      end)
    end)
  end

  def serialize({x, y}), do: "#{x}-#{y}"
end
