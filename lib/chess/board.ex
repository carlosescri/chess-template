defmodule Chess.Board do
  # Logic for the board
  @x_dimension 8
  @y_dimension 8

  @spec get_x_dimension :: pos_integer
  def get_x_dimension(), do: @x_dimension

  @spec get_y_dimension :: pos_integer
  def get_y_dimension(), do: @y_dimension


  def get_square_color(y, x, selected_square) do
    # TODO: Fix this shit
    if selected_square == "#{y}#{x}" do
      "selected"
    else
      black_or_white(x, y)
    end
  end

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

  def type_into_class("k"), do: "king"
  def type_into_class("q"), do: "queen"
  def type_into_class("r"), do: "rook"
  def type_into_class("b"), do: "bishop"
  def type_into_class("kn"), do: "knight"
  def type_into_class("p"), do: "pawn"
end
