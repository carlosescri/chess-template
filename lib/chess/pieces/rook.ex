defmodule Chess.Pieces.Rook do

  def possible_move?(state,
    {current_x, _current_y} = current_position,
    {current_x, _goto_y} = goto_position,
    _
    ), do: avoided_collisions?(state, current_position, goto_position)

  def possible_move?(state,
    {_current_x, current_y} = current_position,
    {_goto_x, current_y} = goto_position,
    _
    ), do: avoided_collisions?(state, current_position, goto_position)

  def possible_move?(_, _, _, _), do: false
  
  def possible_attack?(state, current_position, goto_position, colour),
    do: possible_move?(state, current_position, goto_position, colour)
  
  defp avoided_collisions?(_, _, _), do: true

end
