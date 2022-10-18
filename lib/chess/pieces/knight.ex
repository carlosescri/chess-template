defmodule Chess.Pieces.Knight do

  def possible_move?(
    {current_x, current_y},
    {current_x, goto_y},
    :white
    ) when current_y + 1 == goto_y, do: true
    
  def possible_move?(
    {current_x, current_y},
    {current_x, goto_y},
    :black
    ) when current_y - 1 == goto_y, do: true

  def possible_move?(_, _), do: false
end
