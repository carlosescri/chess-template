defmodule Chess.Gameplay.Position do
  @moduledoc """
  Gameplay position validation
  """

  def is_valid?({row, _}) when not is_integer(row), do: false
  def is_valid?({_, column}) when not is_integer(column), do: false

  def is_valid?({_, column}) when column > 7 or column < 0, do: false
  def is_valid?({row, _}) when row > 7 or row < 0, do: false

  def is_valid?({_, _}), do: true

  def parse(str) do
    with [rs, cs] <- String.split(str, ","),
         {r, _} <- Integer.parse(rs),
         {c, _} <- Integer.parse(cs),
         true <- is_valid?({r, c}) do
      {:ok, {r, c}}
    else
      _ ->
        {:error, "Invalid position"}
    end
  end

  def to_string({r, c}) do
    Integer.to_string(r) <> "," <> Integer.to_string(c)
  end
end
