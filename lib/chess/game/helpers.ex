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
  def to_index({col, row}), do: row * 8 + col

  @doc """
  Returns true if the white player is in its turn
  """
  @spec white_turn?(State.t()) :: boolean
  def white_turn?(%{game_state: state}) when state in [:play_white, :play_white_check], do: true
  def white_turn?(_), do: false
end
