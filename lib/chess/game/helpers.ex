defmodule Chess.Game.Helpers do

  @doc """
  Transforms a list index into coordinates
  """
  @spec to_coord(non_neg_integer) :: tuple
  def to_coord(index), do: {rem(index, 8), div(index, 8)}

  @doc """
  Transforms a coordinate tuple into a list index
  """
  @spec to_index({non_neg_integer, non_neg_integer}) :: non_neg_integer
  def to_index({col, row}), do: col*8 + row
end
