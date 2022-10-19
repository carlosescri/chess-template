defmodule ChessWeb.PageView do
  use ChessWeb, :view

  require Integer

  def is_even(row) do
    Integer.is_even(row + 1)
  end
end
