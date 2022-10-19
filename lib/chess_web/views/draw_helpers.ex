defmodule ChessWeb.DrawHelpers do
  @moduledoc """
  This is the module where all the necessary functions for processing data and drawing
  elements in the canvas are located. All of them return strings that will be added to
  element CSS classes.
  """

  require Integer

  @spec color_class({binary, binary}) :: binary
  def color_class({row, column}) when Integer.is_odd(row) do
    case Integer.is_odd(column) do
      true -> "white"
      false -> "black"
    end
  end

  def color_class({_row, column}) do
    column = column + 1

    case Integer.is_odd(column) do
      true -> "white"
      false -> "black"
    end
  end

  def cell_selected?(state, position) when state.cell_selected == position, do: "selected"
  def cell_selected?(_state, _position), do: ""

  def draw_piece_your_piece(player, position) do
    for piece <- player.you.alive_pieces do
      check_piece(position, piece)
    end
  end

  def draw_piece_enemy_piece(player, position) do
    for piece <- player.enemy.alive_pieces do
      check_piece(position, piece)
    end
  end

  defp check_piece(board_position, piece)
       when board_position === piece.position,
       do: "figure #{piece.color} #{piece.type}"

  defp check_piece(_board_position, %{type: _type, position: _piece_position, color: _color}), do: ""
end
