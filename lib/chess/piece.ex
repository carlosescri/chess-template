defmodule Chess.Piece do
  @moduledoc """
  The chess piece.
  """

  @color_choices [:black, :white]
  @type_choices [:pawn, :rook, :knight, :queen, :king, :bishop]

  def new(type, color \\ :white) when type in @type_choices and color in @color_choices,
    do: %{type: type, color: color}
end
