defmodule Chess.Pieces.Pawn do

  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, current_y},
    :white
    ) when current_x - 1 == goto_x, do: true

  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, current_y},
    :black
    ) when current_x + 1 == goto_x, do: true

  def possible_move?(_, _, _, _), do: false
  
  def possible_attack?(_state, {current_x, current_y}, {goto_x, goto_y}, :white)
    when current_x - 1 == goto_x and current_y - 1 == goto_y, do: true
    
  def possible_attack?(_state, {current_x, current_y}, {goto_x, goto_y}, :white)
    when current_x - 1 == goto_x and current_y + 1 == goto_y, do: true
    
  def possible_attack?(_state, {current_x, current_y}, {goto_x, goto_y}, :black)
    when current_x + 1 == goto_x and current_y - 1 == goto_y, do: true
    
  def possible_attack?(_state, {current_x, current_y}, {goto_x, goto_y}, :black)
    when current_x + 1 == goto_x and current_y + 1 == goto_y, do: true
    
  def possible_attack?(_state, _, _, _), do: false
end
