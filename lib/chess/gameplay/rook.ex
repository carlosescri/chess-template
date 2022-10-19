defmodule Chess.Gameplay.Rook do
  @moduledoc """
  Rook
  """

  alias Chess.Gameplay.Board

  def moves(board, pos) do
    Enum.reduce(
      directions(),
      [],
      fn dir, acc -> acc ++ Board.generate_moves(board, pos, dir) end
    )
  end

  ###########
  # PRIVATE #
  ###########

  defp directions do
    [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
  end
end
