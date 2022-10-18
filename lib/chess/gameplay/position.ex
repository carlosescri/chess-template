defmodule Chess.Gameplay.Position do
  @moduledoc """
  Gameplay position validation
  """

  def is_valid?({row, column}) when column > 7 or column < 0, do: :false
  def is_valid?({row, column}) when row > 7 or row < 0, do: :false
  def is_valid?({row, column}), do: :true
end
