defmodule Chess.Gameplay.Bishop do
  @moduledoc """
  Bishop
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
    [{1, 1}, {1, -1}, {-1, 1}, {-1, -1}]
  end
end
