defmodule Chess.Game.Movements do
  @moduledoc """
  Helper module that implements functions to check if a movement is valid.
  """

  alias Chess.Game.Figure

  defguard in_bounds(col, row) when 0 <= col and col < 8 and 0 <= row and row < 8

  @spec allowed?(Figure.t(), tuple, tuple) :: boolean
  def allowed?(%{type: :knight}, {from_col, from_row}, {to_col, to_row})
      when in_bounds(to_row, to_col) do
    (to_col == from_col - 2 and to_row == from_row - 1) or
      (to_col == from_col - 2 and to_row == from_row + 1) or
      (to_col == from_col - 1 and to_row == from_row - 2) or
      (to_col == from_col - 1 and to_row == from_row + 2) or
      (to_col == from_col + 1 and to_row == from_row - 2) or
      (to_col == from_col + 1 and to_row == from_row + 2) or
      (to_col == from_col + 2 and to_row == from_row - 1) or
      (to_col == from_col + 2 and to_row == from_row + 1)
  end

  def allowed?(_, _, _), do: false
end
