defmodule Chess.Movement do
  alias Chess.Board
  alias Chess.Movement.Bishop
  alias Chess.Movement.Knight
  alias Chess.Movement.King
  alias Chess.Movement.Pawn
  alias Chess.Movement.Queen
  alias Chess.Movement.Rook

  def move(pieces, squares, square_id_origin, square_id_final) do
    {int_square_id_origin, _} = Integer.parse(square_id_origin)
    {int_square_id_final, _} = Integer.parse(square_id_final)

    square_origin = Board.get_square(squares, int_square_id_origin)
    square_final = Board.get_square(squares, int_square_id_final)

    if movement_valid?(pieces, square_origin, square_final) do
      {:ok, do_movement(squares, square_origin, square_final)}
    else
      {:error, squares}
    end
  end

  defp do_movement(squares, square_origin, square_final) do
    new_square_origin = %{square_origin | :chesspiece_id => nil}
    new_square_final = %{square_final | :chesspiece_id => square_origin.chesspiece_id}

    squares = Enum.map(squares, fn square -> if square.id == square_origin.id do new_square_origin else square end end)
    Enum.map(squares, fn square -> if square.id == square_final.id do new_square_final else square end end)
  end

  defp movement_valid?(pieces, square_origin, square_final) do
    possible = if square_final.chesspiece_id do
      Board.pieces_different_color?(pieces, square_origin.chesspiece_id, square_final.chesspiece_id)
    else
      true
    end
    piece = Board.get_piece(pieces, square_origin.chesspiece_id)
    possible and movement_piece_valid?(piece, square_origin, square_final)
  end

  defp movement_piece_valid?(piece, square_origin, square_final) do
    case piece.type do
      "bishop" -> Bishop.movement_valid?(square_origin, square_final)
      "king" -> King.movement_valid?(square_origin, square_final)
      "knight" -> Knight.movement_valid?(square_origin, square_final)
      "pawn" -> Pawn.movement_valid?(square_origin, square_final)
      "queen" -> Queen.movement_valid?(square_origin, square_final)
      "rook" -> Rook.movement_valid?(square_origin, square_final)
      _ -> true
    end
  end
end
