defmodule Chess.Pieces.Bishop do
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
    do: diagonal_positive_movements() ++ diagonal_negative_movements()

  defp capture_movements(piece), do: movements(piece)

  #FIXME Fix wrong movements
  defp diagonal_positive_movements() do
    Enum.reduce(0..7, [], fn x, acc -> acc ++ [{x, x}] end)
  end

  defp diagonal_negative_movements() do
    Enum.reduce(0..7, [], fn x, acc -> acc ++ [{x * -1, x * -1}] end)
  end
end
