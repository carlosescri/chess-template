defmodule Chess.Table.Game do
  def start() do
    pieces = Chess.Table.Pieces.fresh_start
    pieces
  end

end
