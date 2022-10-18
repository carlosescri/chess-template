defmodule Chess.Game.Piece do
  defstruct type: nil, position: nil

  def legal?({x, y}, %{type: :king, position: {current_x, current_y}}),
    do: difference(x, current_x) == 1 and difference(y, current_y) == 1

  def legal?({x, y}, %{type: :queen, position: {current_x, current_y}}), do: true
  def legal?({x, y}, %{type: :rook, position: {current_x, current_y}}), do: true
  def legal?({x, y}, %{type: :bishop, position: {current_x, current_y}}), do: true
  def legal?({x, y}, %{type: :knight, position: {current_x, current_y}}), do: true

  def legal?({x, y}, %{type: :pawn, position: {current_x, current_y}}),
    do: x == current_x and abs(y - current_y) == 1

  defp difference(new, current), do: abs(new - current)
end
