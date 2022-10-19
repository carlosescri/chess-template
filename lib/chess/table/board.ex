defmodule Chess.Table.Board do
  def is_there_an_own_piece?(pieces, position, color) do
    Enum.any?(pieces, fn piece ->
      piece.position == position && piece.color == color && piece.alive
    end)
  end

  def is_there_an_oponent_piece?(pieces, position, color) do
    Enum.any?(pieces, fn piece ->
      piece.position == position && piece.color != color && piece.alive
    end)
  end
end
