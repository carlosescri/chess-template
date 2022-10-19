defmodule Chess.Gameplay.Queen do
  @moduledoc """
  Queen
  """

  alias Chess.Gameplay.Bishop
  alias Chess.Gameplay.Rook

  def moves(board, pos) do
    Bishop.moves(board, pos) ++ Rook.moves(board, pos)
  end
end
