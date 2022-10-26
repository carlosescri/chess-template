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

  def movements(_piece) do
    Enum.reduce(-7..7, [], fn x, acc ->
      Enum.reduce(-7..7, acc, fn y, acc_y ->
        if(x != 1) do
          acc_y ++ [{x, y}]
        else
          acc_y
        end
      end)
    end)
  end

  defp capture_movements(piece), do: movements(piece)
end
