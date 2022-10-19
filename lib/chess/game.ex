defmodule Chess.Game do
  alias Chess.Board

  def start() do
    Board.init_board()
  end
end
