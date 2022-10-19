defmodule Chess.Cell do
  defstruct [:x, :y]
end

defmodule Chess.Piece do
  defstruct [:type, :color]
end

defmodule Chess.Board do
  defstruct cells: %{
              {0, 0} => %Chess.Piece{type: :rook, color: :black},
              {0, 1} => %Chess.Piece{type: :knight, color: :black},
              {0, 2} => %Chess.Piece{type: :bishop, color: :black},
              {0, 3} => %Chess.Piece{type: :queen, color: :black},
              {0, 4} => %Chess.Piece{type: :king, color: :black},
              {0, 5} => %Chess.Piece{type: :bishop, color: :black},
              {0, 6} => %Chess.Piece{type: :knight, color: :black},
              {0, 7} => %Chess.Piece{type: :rook, color: :black},
              {1, 0} => %Chess.Piece{type: :pawn, color: :black},
              {1, 1} => %Chess.Piece{type: :pawn, color: :black},
              {1, 2} => %Chess.Piece{type: :pawn, color: :black},
              {1, 3} => %Chess.Piece{type: :pawn, color: :black},
              {1, 4} => %Chess.Piece{type: :pawn, color: :black},
              {1, 5} => %Chess.Piece{type: :pawn, color: :black},
              {1, 6} => %Chess.Piece{type: :pawn, color: :black},
              {1, 7} => %Chess.Piece{type: :pawn, color: :black},
              {6, 0} => %Chess.Piece{type: :pawn, color: :white},
              {6, 1} => %Chess.Piece{type: :pawn, color: :white},
              {6, 2} => %Chess.Piece{type: :pawn, color: :white},
              {6, 3} => %Chess.Piece{type: :pawn, color: :white},
              {6, 4} => %Chess.Piece{type: :pawn, color: :white},
              {6, 5} => %Chess.Piece{type: :pawn, color: :white},
              {6, 6} => %Chess.Piece{type: :pawn, color: :white},
              {6, 7} => %Chess.Piece{type: :pawn, color: :white},
              {7, 0} => %Chess.Piece{type: :rook, color: :white},
              {7, 1} => %Chess.Piece{type: :knight, color: :white},
              {7, 2} => %Chess.Piece{type: :bishop, color: :white},
              {7, 3} => %Chess.Piece{type: :queen, color: :white},
              {7, 4} => %Chess.Piece{type: :king, color: :white},
              {7, 5} => %Chess.Piece{type: :bishop, color: :white},
              {7, 6} => %Chess.Piece{type: :knight, color: :white},
              {7, 7} => %Chess.Piece{type: :rook, color: :white}
            }
end

defmodule Chess.Game do
  defstruct name: nil,
            initial_position: nil,
            final_position: nil,
            next_player: :white,
            board: %Chess.Board{},
            white: %{removed_pieces: []},
            black: %{removed_pieces: []}
end
