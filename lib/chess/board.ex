defmodule Chess.Board do
  alias Chess.ChessPiece
  alias Chess.Square

  def init() do
    pieces = [
      %ChessPiece{id: 1, white: false, type: "rook"},
      %ChessPiece{id: 2, white: false, type: "knight"},
      %ChessPiece{id: 3, white: false, type: "bishop"},
      %ChessPiece{id: 4, white: false, type: "queen"},
      %ChessPiece{id: 5, white: false, type: "king"},
      %ChessPiece{id: 6, white: false, type: "bishop"},
      %ChessPiece{id: 7, white: false, type: "knight"},
      %ChessPiece{id: 8, white: false, type: "rook"},
      %ChessPiece{id: 9, white: false, type: "pawn"},
      %ChessPiece{id: 10, white: false, type: "pawn"},
      %ChessPiece{id: 11, white: false, type: "pawn"},
      %ChessPiece{id: 12, white: false, type: "pawn"},
      %ChessPiece{id: 13, white: false, type: "pawn"},
      %ChessPiece{id: 14, white: false, type: "pawn"},
      %ChessPiece{id: 15, white: false, type: "pawn"},
      %ChessPiece{id: 16, white: false, type: "pawn"},
      %ChessPiece{id: 17, type: "pawn"},
      %ChessPiece{id: 18, type: "pawn"},
      %ChessPiece{id: 19, type: "pawn"},
      %ChessPiece{id: 20, type: "pawn"},
      %ChessPiece{id: 21, type: "pawn"},
      %ChessPiece{id: 22, type: "pawn"},
      %ChessPiece{id: 23, type: "pawn"},
      %ChessPiece{id: 24, type: "pawn"},
      %ChessPiece{id: 25, type: "rook"},
      %ChessPiece{id: 26, type: "knight"},
      %ChessPiece{id: 27, type: "bishop"},
      %ChessPiece{id: 28, type: "queen"},
      %ChessPiece{id: 29, type: "king"},
      %ChessPiece{id: 30, type: "bishop"},
      %ChessPiece{id: 31, type: "knight"},
      %ChessPiece{id: 32, type: "rook"}
    ]

    squares = Enum.map(1..8, fn x -> %Square{id: x, coordinates: {x, 1}, chesspiece_id: x, white: rem(x, 2) == 1} end)

    squares = squares ++ Enum.map(9..16, fn x -> %Square{id: x, coordinates: {x - 8, 2}, chesspiece_id: x, white: rem(x, 2) == 0} end)

    squares = squares ++ Enum.map(17..24, fn x -> %Square{id: x, coordinates: {x - 16, 3}, white: rem(x, 2) == 1} end)

    squares = squares ++ Enum.map(25..32, fn x -> %Square{id: x, coordinates: {x - 24, 4}, white: rem(x, 2) == 0} end)

    squares = squares ++ Enum.map(33..40, fn x -> %Square{id: x, coordinates: {x - 32, 5}, white: rem(x, 2) == 1} end)

    squares = squares ++ Enum.map(41..48, fn x -> %Square{id: x, coordinates: {x - 40, 6}, white: rem(x, 2) == 0} end)

    squares = squares ++ Enum.map(49..56, fn x -> %Square{id: x, coordinates: {x - 48, 7}, chesspiece_id: x - 32, white: rem(x, 2) == 1} end)

    squares = squares ++ Enum.map(57..64, fn x -> %Square{id: x, coordinates: {x - 56, 8}, chesspiece_id: x - 32, white: rem(x, 2) == 0} end)

    {pieces, squares}
  end

  def get_piece_data(pieces, piece_id) do
    piece = Enum.find(pieces, fn piece -> piece.id == piece_id end)
    if piece.white do
      piece.type <> " " <> "white"
    else
      piece.type <> " " <> "black"
    end
  end

  def get_piece(pieces, piece_id) do
    Enum.find(pieces, fn piece -> piece.id == piece_id end)
  end

  @spec get_square(any, integer()) :: %Square{}
  def get_square(squares, square_id) do
    Enum.find(squares, fn square -> square.id == square_id end)
  end

  def pieces_different_color?(pieces, piece_id_1, piece_id_2) do
    piece_1 = get_piece(pieces, piece_id_1)
    piece_2 = get_piece(pieces, piece_id_2)
    piece_1.white != piece_2.white
  end
end
