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

  def get_color(row, col) when is_even(row) and is_even(col) or is_odd(row) and is_odd(col)do
    "white"
  end

  def get_color(row, col) when is_even(row) and is_odd(col) or is_odd(row) and is_even(col) do
    "black"
  end

  def get_figure(board, row, col) do
    Board.get_at(board, row, col)
  end

  def get_figure_class(board, row, col) do
    %Figure{color: color, type: type} = get_figure(board, row, col)

    "#{color} #{type}"
  end
end
