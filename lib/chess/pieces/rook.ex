defmodule Chess.Pieces.Rook do
  alias Chess.Board
  alias Chess.Piece

  def can_capture?(%{color: :white} = selected_piece, %{color: :black}, move) do
    Enum.member?(capture_movements(selected_piece), move)
  end

  def can_capture?(%{color: :black} = selected_piece, %{color: :white}, move) do
    Enum.member?(capture_movements(selected_piece), move)
  end

  def can_capture?(_selected_piece, _target_piece, _move), do: false

  def movements(_piece),
    do:
      vertical_positive_movements() ++
        vertical_negative_movements() ++
        horizontal_positive_movements() ++ horizontal_negative_movements

  defp capture_movements(piece), do: movements(piece)

  defp vertical_positive_movements() do
    Enum.reduce(0..7, [], fn y, acc -> acc ++ [{0, y}] end)
  end

  defp vertical_negative_movements() do
    Enum.reduce(0..7, [], fn y, acc -> acc ++ [{0, y * -1}] end)
  end

  defp horizontal_positive_movements() do
    Enum.reduce(0..7, [], fn x, acc -> acc ++ [{x, 0}] end)
  end

  defp horizontal_negative_movements() do
    Enum.reduce(0..7, [], fn x, acc -> acc ++ [{x * -1, 0}] end)
  end
end
