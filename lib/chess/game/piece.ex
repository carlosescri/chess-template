defmodule Chess.Game.Piece do
  defstruct type: nil, position: nil

  def legal_move?({x, y}, %{type: :king, position: {current_x, current_y}}),
    do: difference(x, current_x) == 1 or difference(y, current_y) == 1

  def legal_move?(position, %{type: :queen, position: current_position}) do
    horizontal_move?(position, current_position) or
      vertical_move?(position, current_position) or
      diagonal_move?(position, current_position)
  end

  def legal_move?(position, %{type: :rook, position: current_position}) do
    horizontal_move?(position, current_position) or
      vertical_move?(position, current_position)
  end

  def legal_move?(position, %{type: :bishop, position: current_position}),
    do: diagonal_move?(position, current_position)

  def legal_move?({x, y}, %{type: :knight, position: {current_x, current_y}}) do
    (difference(x, current_x) == 2 and difference(y, current_y) == 1) or
      (difference(y, current_y) == 2 and difference(x, current_x) == 1)
  end

  def legal_move?({x, y}, %{type: :pawn, position: {current_x, current_y}}),
    do: x == current_x and difference(y, current_y) > 0 and difference(y, current_y) <= 2

  # priv: helpers

  defp horizontal_move?({x, y}, {current_x, current_y}),
    do: y == current_y and difference(x, current_x) > 0

  defp vertical_move?({x, y}, {current_x, current_y}),
    do: x == current_x and difference(y, current_y) > 0

  defp diagonal_move?({x, y}, {current_x, current_y}),
    do: difference(x, current_x) == difference(y, current_y)

  defp difference(new, current), do: abs(new - current)
end
