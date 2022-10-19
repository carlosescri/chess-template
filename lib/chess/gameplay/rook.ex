defmodule Chess.Gameplay.Rook do
  @moduledoc """
  Rook
  """

  alias Chess.Gameplay.Board

  def moves(board, pos) do
    Enum.reduce(directions(), [], &(&2 ++ Board.generate_moves(board, pos, &1)))
  end

  ###########
  # PRIVATE #
  ###########

  defp directions do
    [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
  end
end
