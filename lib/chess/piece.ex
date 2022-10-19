defmodule Chess.Piece do

  alias Chess.Pieces.King
  alias Chess.Pieces.Rook
  alias Chess.Pieces.Queen
  alias Chess.Pieces.Pawn
  alias Chess.Pieces.Bishop
  alias Chess.Pieces.Knight

  def possible_move?(state, current_possition, goto_position, colour, :king),
    do: King.possible_move?(state, current_possition, goto_position, colour)

  def possible_move?(state, current_possition, goto_position, colour, :rook),
    do: Rook.possible_move?(state, current_possition, goto_position, colour)

  def possible_move?(state, current_possition, goto_position, colour, :queen),
    do: Queen.possible_move?(state, current_possition, goto_position, colour)

  def possible_move?(state, current_possition, goto_position, colour, :knight),
    do: Knight.possible_move?(state, current_possition, goto_position, colour)

  def possible_move?(state, current_possition, goto_position, colour, :pawn),
    do: Pawn.possible_move?(state, current_possition, goto_position, colour)

  def possible_move?(state, current_possition, goto_position, colour, :bishop),
    do: Bishop.possible_move?(state, current_possition, goto_position, colour)

  def possible_move?(_, _, _, _, _), do: false
  
  def possible_attack?(state, current_possition, goto_position, colour, :king),
    do: King.possible_attack?(state, current_possition, goto_position, colour)

  def possible_attack?(state, current_possition, goto_position, colour, :rook),
    do: Rook.possible_attack?(state, current_possition, goto_position, colour)

  def possible_attack?(state, current_possition, goto_position, colour, :queen),
    do: Queen.possible_attack?(state, current_possition, goto_position, colour)

  def possible_attack?(state, current_possition, goto_position, colour, :knight),
    do: Knight.possible_attack?(state, current_possition, goto_position, colour)

  def possible_attack?(state, current_possition, goto_position, colour, :pawn),
    do: Pawn.possible_attack?(state, current_possition, goto_position, colour)

  def possible_attack?(state, current_possition, goto_position, colour, :bishop),
    do: Bishop.possible_attack?(state, current_possition, goto_position, colour)

  def possible_attack?(state, _, _, _, _, _), do: false

end
