defmodule Chess.Pieces.Pawn do
  alias Chess.Board
  alias Chess.Piece

  def can_capture?(%{color: :white} = selected_piece, %{color: :black}, move) do
    Enum.member?(capture_movements(selected_piece), move)
  end

  def can_capture?(%{color: :black} = selected_piece, %{color: :white}, move) do
    Enum.member?(capture_movements(selected_piece), move)
  end

  def can_capture?(_selected_piece, nil, _move), do: false

  def movements(%{color: :white, first_move: true}), do: [{0, 1}, {0, 2}]
  def movements(%{color: :white, first_move: false}), do: [{0, 1}]
  def movements(%{color: :black, first_move: true}), do: [{0, -1}, {0, -2}]
  def movements(%{color: :black, first_move: false}), do: [{0, -1}]
  defp capture_movements(%{color: :white}), do: [{-1, 1}, {1, 1}]
  defp capture_movements(%{color: :black}), do: [{1, -1}, {-1, 1}]
end
