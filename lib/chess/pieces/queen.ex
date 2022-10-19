defmodule Chess.Pieces.Queen do

  def possible_move?(_state,
    {current_x, current_y},
    {current_x, goto_y},
    :white
    ) when current_y + 1 == goto_y, do: true

  def possible_move?(_state,
    {current_x, current_y},
    {current_x, goto_y},
    :black
    ) when current_y - 1 == goto_y, do: true

  def possible_move?(_, _, _, _), do: false
  
  def possible_attack?(state, current_position, goto_position, colour),
    do: possible_move?(state, current_position, goto_position, colour)
end
