defmodule Chess.Table.Piece do
  @enforce_keys [
    :name,
    :position,
    :color
  ]
  defstruct [
    :name,
    :position,
    :color,
    alive: true
  ]
end
