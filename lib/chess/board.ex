defmodule Chess.Board do
  # Logic for the board
  @x_dimension 8
  @y_dimension 8

  @spec get_x_dimension :: pos_integer
  def get_x_dimension(), do: @x_dimension

  @spec get_y_dimension :: pos_integer
  def get_y_dimension(), do: @y_dimension


  def get_square_color(x, y, selected_square) do
    # TODO: Fix this shit
    if selected_square == x_y_into_chess_square(x, y) do
      "selected"
    else
      if rem(y, 2) == 0 do
        if rem(x, 2) == 0 do
          "black"
        else
          "white"
        end
      else
        if rem(x, 2) == 0 do
          "white"
        else
          "black"
        end
      end
    end
  end

  def is_piece(x, y, pieces) do
    letter = x_y_into_chess_square(x, y)
    piece = Map.get(pieces, letter)
    piece_into_class(piece)
  end

  def x_y_into_chess_square(x, y) do
    letter = List.to_string([64 + y])
    "#{letter}#{x}"
  end

  def piece_into_class(nil), do: nil
  def piece_into_class({is_black, type}) do
    "#{black_into_class(is_black)} #{type_into_class(type)}"
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
