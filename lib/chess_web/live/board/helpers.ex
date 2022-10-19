defmodule ChessWeb.Board.Helpers do
  @moduledoc """
  Function components for board drawing
  """

  use ChessWeb, :component

  def tile_content(%{figure: nil}), do: ""

  def tile_content(assigns) do
    ~H"""
    <div class={"figure #{Atom.to_string(@figure.type)} #{Atom.to_string(@figure.color)}"}></div>
    """
  end
end
