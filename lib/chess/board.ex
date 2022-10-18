defmodule Chess.Board do
  # Logic for the board
  @x_dimension 8
  @y_dimension 8

  @spec get_x_dimension :: pos_integer
  def get_x_dimension(), do: @x_dimension

  @spec get_y_dimension :: pos_integer
  def get_y_dimension(), do: @y_dimension
end
