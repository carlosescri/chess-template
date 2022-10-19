defmodule Chess.Table.EmptyBoard do
  @y_axis [1, 2, 3, 4, 5, 6, 7, 8]
  @x_axis ["A", "B", "C", "D", "E", "F", "G", "H"]

  def x_axis, do: @x_axis
  def y_axis, do: @y_axis
end
