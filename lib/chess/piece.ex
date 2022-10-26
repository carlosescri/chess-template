defmodule Chess.Piece do
  alias Chess.Board
  alias Chess.Pieces.Pawn
  alias Chess.Pieces.Rook
  alias Chess.Pieces.Bishop

  # TODO: Implement missing pieces
  # alias Chess.Pieces.Queen
  # alias Chess.Pieces.King
  # alias Chess.Pieces.Knight

  @types %{
    color: :string,
    type: :string,
    first_move: :boolean
  }

  defstruct color: :white,
            type: nil,
            first_move: true

  def can_move?(piece, board, origin = {or_x, or_y}, target = {tar_x, tar_y}) do
    move_x = tar_x - or_x
    move_y = tar_y - or_y

    IO.puts(
      "move from #{or_x}, #{or_y} to #{tar_x}, #{tar_y}, needs to move #{move_x} cells horizontal and #{move_y} cells vertical"
    )

    move = {move_x, move_y}

    IO.inspect(move, label: "move units")
    valid_movements = movements(piece)
    IO.inspect(valid_movements, label: "valid_movements")

    target_piece = Board.find_piece(board, tar_x, tar_y)

    can_capture?(piece, target_piece, move) ||
      (Enum.member?(valid_movements, move) && !check_obstruction(piece, board, origin, move))
  end

  def can_capture?(%{type: "pawn"} = piece, target_piece, move) do
    Pawn.can_capture?(piece, target_piece, move)
  end

  def movements(%{type: "pawn"} = piece) do
    Pawn.movements(piece)
  end

  def movements(%{type: "rook"} = piece) do
    Rook.movements(piece)
  end

  def can_capture?(%{type: "rook"} = piece, target_piece, move) do
    Rook.can_capture?(piece, target_piece, move)
  end

  def movements(%{type: "bishop"} = piece) do
    Bishop.movements(piece)
  end

  def can_capture?(%{type: "bishop"} = piece, target_piece, move) do
    Bishop.can_capture?(piece, target_piece, move)
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
