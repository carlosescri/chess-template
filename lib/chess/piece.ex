defmodule Chess.Piece do
  
  alias Chess.Pieces.King
  alias Chess.Pieces.Rook
  alias Chess.Pieces.Queen
  alias Chess.Pieces.Pawn
  alias Chess.Pieces.Bishop
  alias Chess.Pieces.Knight
    
  # possible_attack?(tuple, tuple, atom) :: Boolean.t()
  
  def possible_move?(current_possition, goto_position, colour, :king),
    do: King.possible_move?(current_possition, goto_position, colour)
    
  def possible_move?(current_possition, goto_position, colour, :rook),
    do: Rook.possible_move?(current_possition, goto_position, colour)
    
  def possible_move?(current_possition, goto_position, colour, :queen),
    do: Queen.possible_move?(current_possition, goto_position, colour)
    
  def possible_move?(current_possition, goto_position, colour, :knight),
    do: Knight.possible_move?(current_possition, goto_position, colour)
        
  def possible_move?(current_possition, goto_position, colour, :pawn),
    do: Pawn.possible_move?(current_possition, goto_position, colour)
    
  def possible_move?(current_possition, goto_position, colour, :bishop),
    do: Bishop.possible_move?(current_possition, goto_position, colour)
        
  def possible_move?(_, _, _, _), do: false

end
