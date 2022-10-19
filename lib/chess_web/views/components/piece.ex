defmodule Piece do
  use Phoenix.Component

  def print(assigns) do
    {piece, color} = assigns.piece
    ~H"""
    <div class={"figure #{Atom.to_string(color)} #{Atom.to_string(piece)}"}></div>
    """
  end
end