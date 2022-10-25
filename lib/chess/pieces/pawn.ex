defmodule Chess.Pieces.Pawn do
  alias Chess.Board
  alias Chess.Piece

  def can_move?(%{type: "pawn"} = piece, board, origin = {or_x, or_y}, target = {tar_x, tar_y}) do
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
      (Enum.member?(valid_movements, move) && !Piece.check_obstruction(piece, board, origin, move))
  end

  def can_capture?(%{color: :white} = selected_piece, %{color: :black}, move) do
    Enum.member?(capture_movements(selected_piece), move)
  end

  def can_capture?(%{color: :black} = selected_piece, %{color: :white}, move) do
    Enum.member?(capture_movements(selected_piece), move)
  end

  def can_capture?(_selected_piece, nil, _move), do: false

  defp valid_movements(piece) do
    movements(piece) ++ capture_movements(piece)
  end

  defp movements(%{color: :white, first_move: true}), do: [{0, 1}, {0, 2}]
  defp movements(%{color: :white, first_move: false}), do: [{0, 1}]
  defp movements(%{color: :black, first_move: true}), do: [{0, -1}, {0, -2}]
  defp movements(%{color: :black, first_move: false}), do: [{0, -1}]

  defp capture_movements(%{color: :white}), do: [{-1, 1}, {1, 1}]
  defp capture_movements(%{color: :black}), do: [{1, -1}, {-1, 1}]
end
