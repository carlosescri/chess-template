defmodule Chess.Pieces.King do

  alias Chess.Piece
  
  def possible_move?(
    {current_x, current_y},
    {current_x, goto_y},
    _colour
    ) when current_y + 1 == goto_y or current_y - 1 == goto_y, do: true
    
  def possible_move?(
    {current_x, current_y},
    {goto_x, current_y},
    _colour
    ) when current_x + 1 == goto_x or current_x - 1 == goto_x, do: true

  def possible_move?(
    {current_x, current_y},
    {goto_x, goto_y},
    _colour
    ) when current_x + 1 == goto_x and current_y + 1 == goto_y, do: true

  def possible_move?(
    {current_x, current_y},
    {goto_x, goto_y},
    _colour
    ) when current_x - 1 == goto_x and current_y - 1 == goto_y, do: true
    
  def possible_move?(
    {current_x, current_y},
    {goto_x, goto_y},
    _colour
    ) when current_x - 1 == goto_x and current_y + 1 == goto_y, do: true

  def possible_move?(
    {current_x, current_y},
    {goto_x, goto_y},
    _colour
    ) when current_x + 1 == goto_x and current_y - 1 == goto_y, do: true

  def possible_move?(_, _), do: false
  
  @impl Piece
  def possible_attack?(_, _, _), do: true
end
