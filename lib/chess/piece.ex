defmodule Chess.Piece do
  alias Chess.Pieces.Pawn
  #alias Chess.Pieces.King
  #alias Chess.Pieces.Rook
  #alias Chess.Pieces.Queen
  #alias Chess.Pieces.Bishop
  #alias Chess.Pieces.Knight

  @types %{
    color: :string,
    type: :string,
    first_move: :boolean
  }

  defstruct color: :white,
            type: nil,
            first_move: true

  def can_move?(%{type: "pawn"} = piece, board, origin, target) do
    Pawn.can_move?(piece, board, origin, target)
  end

  def generate_steps({x, y}) when x = 0 do
    for [] <-  do

    end
  end
end
