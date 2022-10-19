defmodule Chess.Table.Pieces do
  def fresh_start do
    _pieces = [
      %Chess.Table.Piece{name: :rook, position: "A1", color: :white},
      %Chess.Table.Piece{name: :knight, position: "B1", color: :white},
      %Chess.Table.Piece{name: :bishop, position: "C1", color: :white},
      %Chess.Table.Piece{name: :queen, position: "D1", color: :white},
      %Chess.Table.Piece{name: :king, position: "E1", color: :white},
      %Chess.Table.Piece{name: :bishop, position: "F1", color: :white},
      %Chess.Table.Piece{name: :knight, position: "G1", color: :white},
      %Chess.Table.Piece{name: :rook, position: "H1", color: :white},
      %Chess.Table.Piece{name: :pawn, position: "A2", color: :white},
      %Chess.Table.Piece{name: :pawn, position: "B2", color: :white},
      %Chess.Table.Piece{name: :pawn, position: "C2", color: :white},
      %Chess.Table.Piece{name: :pawn, position: "D2", color: :white},
      %Chess.Table.Piece{name: :pawn, position: "E2", color: :white},
      %Chess.Table.Piece{name: :pawn, position: "F2", color: :white},
      %Chess.Table.Piece{name: :pawn, position: "G2", color: :white},
      %Chess.Table.Piece{name: :pawn, position: "H2", color: :white},
      %Chess.Table.Piece{name: :rook, position: "A8", color: :black},
      %Chess.Table.Piece{name: :knight, position: "B8", color: :black},
      %Chess.Table.Piece{name: :bishop, position: "C8", color: :black},
      %Chess.Table.Piece{name: :queen, position: "D8", color: :black},
      %Chess.Table.Piece{name: :king, position: "E8", color: :black},
      %Chess.Table.Piece{name: :bishop, position: "F8", color: :black},
      %Chess.Table.Piece{name: :knight, position: "G8", color: :black},
      %Chess.Table.Piece{name: :rook, position: "H8", color: :black},
      %Chess.Table.Piece{name: :pawn, position: "A7", color: :black},
      %Chess.Table.Piece{name: :pawn, position: "B7", color: :black},
      %Chess.Table.Piece{name: :pawn, position: "C7", color: :black},
      %Chess.Table.Piece{name: :pawn, position: "D7", color: :black},
      %Chess.Table.Piece{name: :pawn, position: "E7", color: :black},
      %Chess.Table.Piece{name: :pawn, position: "F7", color: :black},
      %Chess.Table.Piece{name: :pawn, position: "G7", color: :black},
      %Chess.Table.Piece{name: :pawn, position: "H7", color: :black}
    ]
  end
end
