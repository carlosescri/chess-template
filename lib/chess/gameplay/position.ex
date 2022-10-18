defmodule Chess.Gameplay.Position do
  @moduledoc """
  Gameplay position validation
  """

  def is_valid?({row, _}) when not is_integer(row), do: false
  def is_valid?({_, column}) when not is_integer(column), do: false

  def is_valid?({_, column}) when column > 7 or column < 0, do: false
  def is_valid?({row, _}) when row > 7 or row < 0, do: false

  def is_valid?({_, _}), do: true
end
