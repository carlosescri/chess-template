defmodule Chess.Pieces.Bishop do

  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _colour
    ) when current_y + current_x == goto_y + goto_x, do: true

  def possible_move?(_, _, _, _), do: false
  
  def possible_attack?(state, current_position, goto_position, colour),
    do: possible_move?(state, current_position, goto_position, colour)
  
end
