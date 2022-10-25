defmodule Chess.Piece do
  alias Chess.Board
  alias Chess.Pieces.Pawn
  # alias Chess.Pieces.King
  # alias Chess.Pieces.Rook
  # alias Chess.Pieces.Queen
  # alias Chess.Pieces.Bishop
  # alias Chess.Pieces.Knight

  @types %{
    color: :string,
    type: :string,
    first_move: :boolean
  }

  defstruct color: :white,
            type: nil,
            first_move: true

  def can_move?(%{type: "pawn"} = piece, board, origin, target) do
    Pawn.can_move?(piece, board, origin, target)
  end

  def can_capture?(%{type: "pawn"} = piece, target_piece, move) do
    Pawn.can_capture?(piece, target_piece, move)
  end

  def check_obstruction(selected_piece, board, {x_origin, y_origin}, move) do
    move_steps = generate_steps(move)
    IO.inspect(move_steps, label: "move_steps")

    IO.inspect(move, label: "MOVE")

    ch_obs =
      Enum.reduce_while(move_steps, false, fn {x, y} = move, acc ->
        x = x_origin + x
        y = y_origin + y
        IO.puts("Check obstruction in pos x=#{x}, y=#{y}")
        target_piece = Board.find_piece(board, x, y)
        if target_piece != nil && !can_capture?(selected_piece, target_piece, move) do

          IO.inspect(target_piece, label: "There is a piece obstructing at #{x}, #{y}")
          {:halt, true}
        else
          {:cont, acc}
        end
      end)

    IO.inspect(ch_obs, label: "Obstruction result")
  end



  defp generate_steps({x, y} = move) do
    steps =
      case get_move_type(move) do
        :diagonal -> generate_diagonal_steps(move)
        :vertical -> generate_vertical_steps(move)
        :horizontal -> generate_horizontal_steps(move)
      end

    IO.inspect(steps, label: "Needed steps")
    steps
  end

  defp generate_diagonal_steps({x, _y}) do
    IO.puts("DIAGONAL")
    x_range = get_range(x)
    steps = Enum.reduce(x_range, [], fn x, acc -> acc ++ [{x, x}] end)
    if x > 0, do: steps, else: Enum.reverse(steps)
  end

  defp generate_vertical_steps({_, y}) do
    IO.puts("VERTICAL")
    y_range = get_range(y)
    steps = Enum.reduce(y_range, [], fn y, acc -> acc ++ [{0, y}] end)
    if y > 0, do: steps, else: Enum.reverse(steps)
  end

  defp generate_horizontal_steps({x, _y}) do
    IO.puts("HORIZONTAL")
    x_range = get_range(x)
    steps = Enum.reduce(x_range, [], fn x, acc -> acc ++ [{x, 0}] end)
    if x > 0, do: steps, else: Enum.reverse(steps)
  end

  defp get_range(n) do
    if n > 0, do: 1..n, else: n..-1
  end

  defp get_move_type({x, y}) when x == y, do: :diagonal
  defp get_move_type({x, y}) when x == 0, do: :vertical
  defp get_move_type({x, y}) when y == 0, do: :horizontal
  defp get_move_type(move) do
    IO.inspect(move, label: "otra condicion para diagonal")
    :diagonal
  end
end
