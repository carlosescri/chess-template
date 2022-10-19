defmodule Chess.Gameplay.Knight do
  @moduledoc """
  Knight
  """

  alias Chess.Gameplay.Board

  def moves(board, {c, r}) do
    Board.generate_moves(
      board,
      {c, r},
      Enum.map(possible_changes(), fn {dc, dr} -> {c + dc, r + dr} end)
    )
  end

  ###########
  # PRIVATE #
  ###########

  defp possible_changes do
    [{1, 2}, {2, 1}, {-1, 2}, {-2, 1}, {1, -2}, {2, -1}, {-1, -2}, {-2, -1}]
  end
end
