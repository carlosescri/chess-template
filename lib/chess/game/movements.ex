defmodule Chess.Game.Movements do
  @moduledoc """
  Helper module that implements functions to check if a movement is valid.
  """

  import Chess.Game.Helpers

  alias Chess.Game.Tile

  defguard in_bounds(col, row) when 0 <= col and col < 8 and 0 <= row and row < 8

  @spec allowed?(list, Tile.t(), Tile.t()) :: boolean
  def allowed?(_, %{figure: %{color: color}}, %{figure: %{color: color}}), do: false

  def allowed?(_, _, %{coordinates: {to_col, to_row}}) when not in_bounds(to_col, to_row),
    do: false

  # def allowed?(board, %{figure: %{type: :rook}, coordinates: {col, from_row}}, %{coordinates: {col, to_row}}) when from_row > to_row do
  #   allowed?(board, )
  # end

  # def allowed?(board, %{figure: %{type: :rook}, coordinates: {col, from_row}}, %{coordinates: {col, to_row}}) when from_row < to_row do

  # end

  # def allowed?(board, %{figure: %{type: :rook}, coordinates: {from_col, row}}, %{coordinates: {to_col, row}}) when from_col > to_col do
  #   true
  # end

  # def allowed?(board, %{figure: %{type: :rook}, coordinates: {from_col, row}}, %{coordinates: {to_col, row}}) when from_col < to_col do
  #   true
  # end

  def allowed?(_, %{figure: %{type: :knight}, coordinates: {from_col, from_row}}, %{
        coordinates: {to_col, to_row}
      }) do
    (to_col == from_col - 2 and to_row == from_row - 1) or
      (to_col == from_col - 2 and to_row == from_row + 1) or
      (to_col == from_col - 1 and to_row == from_row - 2) or
      (to_col == from_col - 1 and to_row == from_row + 2) or
      (to_col == from_col + 1 and to_row == from_row - 2) or
      (to_col == from_col + 1 and to_row == from_row + 2) or
      (to_col == from_col + 2 and to_row == from_row - 1) or
      (to_col == from_col + 2 and to_row == from_row + 1)
  end

  def allowed?(board, %{figure: %{type: :bishop}, coordinates: {from_col, from_row}}, %{
        coordinates: {to_col, to_row}
      }) do
    false
  end

  def allowed?(board, %{figure: %{type: :queen}, coordinates: {from_col, from_row}}, %{
        coordinates: {to_col, to_row}
      }) do
    false
  end

  def allowed?(board, %{figure: %{type: :king}, coordinates: {from_col, from_row}}, %{
        coordinates: {to_col, to_row}
      }) do
    false
  end

  def allowed?(board, %{figure: %{type: :pawn}, coordinates: {from_col, from_row}}, %{
        coordinates: {to_col, to_row}
      }) do
    false
  end

  def allowed?(_board, %{figure: %{type: :rook}, coordinates: {col, _from_row}}, %{
        coordinates: {col, _to_row}
      }) do
    true
  end

  def allowed?(_board, %{figure: %{type: :rook}, coordinates: {_from_col, row}}, %{
        coordinates: {_to_col, row}
      }) do
    true
  end

  def allowed?(_board, %{figure: %{type: :rook}}, _) do
    false
  end

  def allowed?(_, _, _), do: false
end
