defmodule ChessWeb.Components do
  use ChessWeb, :view

  import Chess, only: [is_even: 1, is_odd: 1]

  alias Chess.Game.Board
  alias Chess.Game.Figure

  def board(assigns) do
    render("board.html", assigns)
  end

  def square(assigns) do
    render("square.html", assigns)
  end

  def get_color(row, col) when is_even(row + col), do: "white"

  def get_color(_, _), do: "black"


  def get_figure(board, row, col) do
    Board.get_at(board, row, col)
  end

  def get_figure_class(board, row, col) do
    %Figure{color: color, type: type} = get_figure(board, row, col)

    "#{color} #{type}"
  end

  def is_selectable(figure) do
    if is_nil(figure), do: "", else: "selectable"
  end
end
