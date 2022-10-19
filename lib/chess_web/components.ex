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

  def is_selectable(nil), do: ""
  def is_selectable(_), do: "selectable"

  def is_selected({selected_row, selected_col}, row, col) when selected_row == row and selected_col == col, do: true
  def is_selected(_, _, _), do: false

  def get_selected(true), do: "selected"
  def get_selected(false), do: ""
end
