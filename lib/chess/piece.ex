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

    move = {move_x, move_y}
    valid_movements = movements(piece)

    target_piece = Board.find_piece(board, tar_x, tar_y)

    # FIXME: fix obstruction movements for BISHOP
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

    ch_obs =
      Enum.reduce_while(move_steps, false, fn {x, y} = move, acc ->
        x = x_origin + x
        y = y_origin + y
        target_piece = Board.find_piece(board, x, y)

        if target_piece != nil && !can_capture?(selected_piece, target_piece, move) do
          {:halt, true}
        else
          {:cont, acc}
        end
      end)
  end

  defp generate_steps({x, y} = move) do
    steps =
      case get_move_type(move) do
        :diagonal -> generate_diagonal_steps(move)
        :vertical -> generate_vertical_steps(move)
        :horizontal -> generate_horizontal_steps(move)
      end

    steps
  end

  defp generate_diagonal_steps({x, _y}) do
    x_range = get_range(x)
    steps = Enum.reduce(x_range, [], fn x, acc -> acc ++ [{x, x}] end)
    if x > 0, do: steps, else: Enum.reverse(steps)
  end

  defp generate_vertical_steps({_, y}) do
    y_range = get_range(y)
    steps = Enum.reduce(y_range, [], fn y, acc -> acc ++ [{0, y}] end)
    if y > 0, do: steps, else: Enum.reverse(steps)
  end

  defp generate_horizontal_steps({x, _y}) do
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
end
