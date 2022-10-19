defmodule Chess.Pieces.Knight do

  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _
    ) when current_x + 1 == goto_x and current_y + 2 == goto_y, do: true
    
  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _
    ) when current_x + 1 == goto_x and current_y - 2 == goto_y, do: true
    
  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _
    ) when current_x - 1 == goto_x and current_y + 2 == goto_y, do: true
    
  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _
    ) when current_x - 1 == goto_x and current_y - 2 == goto_y, do: true
    
  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _
    ) when current_y + 1 == goto_y and current_x + 2 == goto_x, do: true
    
  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _
    ) when current_y + 1 == goto_y and current_x - 2 == goto_x, do: true
    
  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _
    ) when current_y - 1 == goto_y and current_x + 2 == goto_x, do: true
    
  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _
    ) when current_y - 1 == goto_y and current_x - 2 == goto_x, do: true
  

  def possible_move?(_, _, _, _), do: false
  
  def possible_attack?(state, current_position, goto_position, colour),
    do: possible_move?(state, current_position, goto_position, colour)
end
