defmodule Chess.Gameplay.Position do
  @moduledoc """
  Gameplay position validation
  """

  def is_valid?({col, _}) when not is_integer(col), do: false
  def is_valid?({_, row}) when not is_integer(row), do: false

  def is_valid?({_, row}) when row > 7 or row < 0, do: false
  def is_valid?({col, _}) when col > 7 or col < 0, do: false

  def is_valid?({_, _}), do: true

  def parse(str) do
    with [cs, rs] <- String.split(str, ","),
         {c, _} <- Integer.parse(cs),
         {r, _} <- Integer.parse(rs),
         true <- is_valid?({c, r}) do
      {:ok, {c, r}}
    else
      _ ->
        {:error, "Invalid position"}
    end
  end

  def to_string({c, r}), do: "#{c},#{r}"
end
