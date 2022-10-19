defmodule ChessWeb.Board do
  @moduledoc """
  This module contains useful function to help the board to be rendered, like
  when a piece must be drawn and which css classes needs, or the color of the
  square to be drawn.
  """

  # Maximum dimensions could the changed in the future to explore other kind
  # of alternative chess games.
  @x_dimension 8
  @y_dimension 8

  @spec get_x_dimension :: pos_integer
  def get_x_dimension(), do: @x_dimension

  @spec get_y_dimension :: pos_integer
  def get_y_dimension(), do: @y_dimension


  @doc """
  This function gets the css classs with the color of the square to be
  rendered.

  If the given square is the

  Requires:
    - y: the number of the column
    - x: the number of the row
    - selected_square: the square that is already selected.

  Returns black or white, or selected if the given square is the selected
  square.
  """
  def get_square_color(y, x, selected_square) do
    # TODO: Fix this shit
    if selected_square == "#{y}#{x}" do
      "selected"
    else
      black_or_white(x, y)
    end
  end

  @doc """
  This function chooses to draw a square in black or white, given the column
  and the row.

  This can be determined in a very simple way: if both the column and the row
  are even numbers or odd numbers, renders black. If one of them is odd and the
  other is even, renders white.
  white.

  Examples:
    - square 11 == 1/2

  Return "black" or "white"
  """
  defp black_or_white(x, y) do
    if rem(y, 2) == rem(x, 2) do
      "black"
    else
      "white"
    end
  end

  def draw_piece(x, y, pieces) do
    pieces
    |> Map.get("#{y}#{x}")
    |> piece_into_class()
  end

  def piece_into_class(nil), do: nil
  def piece_into_class({is_black, type}) do
    "#{black_into_class(is_black)} #{type}"
  end

  def black_into_class(true), do: "black"
  def black_into_class(false), do: "white"
end
