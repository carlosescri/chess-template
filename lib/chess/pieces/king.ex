defmodule Chess.Pieces.King do

  def possible_move?(_state,
    {current_x, current_y},
    {current_x, goto_y},
    _colour
    ) when current_y + 1 == goto_y or current_y - 1 == goto_y, do: true

  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, current_y},
    _colour
    ) when current_x + 1 == goto_x or current_x - 1 == goto_x, do: true

  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _colour
    ) when current_x + 1 == goto_x and current_y + 1 == goto_y, do: true

  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _colour
    ) when current_x - 1 == goto_x and current_y - 1 == goto_y, do: true

  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _colour
    ) when current_x - 1 == goto_x and current_y + 1 == goto_y, do: true

  def possible_move?(_state,
    {current_x, current_y},
    {goto_x, goto_y},
    _colour
    ) when current_x + 1 == goto_x and current_y - 1 == goto_y, do: true

  def possible_move?(_, _, _, _), do: false
  
  def possible_attack?(state, current_position, goto_position, colour),
    do: possible_move?(state, current_position, goto_position, colour)
end
