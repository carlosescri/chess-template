defmodule Chess.Game.State do
  defstruct white: [], black: [], turn: :white

  alias Chess.Game

  # Horizontal moves
  def legal_move?({x, y}, {current_x, y}, state) when x > current_x do
    free_path?({current_x + 1, y}, {x, y}, Game.get_all_pieces(state), :right)
  end

  def legal_move?({x, y}, {current_x, y}, state) when x < current_x do
    free_path?({current_x - 1, y}, {x, y}, Game.get_all_pieces(state), :left)
  end

  # Vertical moves
  def legal_move?({x, y}, {x, current_y}, state) when y > current_y do
    free_path?({x, current_y + 1}, {x, y}, Game.get_all_pieces(state), :up)
  end

  def legal_move?({x, y}, {x, current_y}, state) when y < current_y do
    free_path?({x, current_y - 1}, {x, y}, Game.get_all_pieces(state), :down)
  end

  # Diagonal moves
  def legal_move?({x, y}, {current_x, current_y}, state)
      when x - current_x > 0 and y - current_y > 0 and x - current_x == y - current_y do
    free_path?({current_x + 1, current_y + 1}, {x, y}, Game.get_all_pieces(state), :upright)
  end

  def legal_move?({x, y}, {current_x, current_y}, state)
      when x - current_x < 0 and y - current_y > 0 and abs(x - current_x) == y - current_y do
    free_path?({current_x - 1, current_y + 1}, {x, y}, Game.get_all_pieces(state), :upleft)
  end

  def legal_move?({x, y}, {current_x, current_y}, state)
      when x - current_x > 0 and y - current_y < 0 and x - current_x == abs(y - current_y) do
    free_path?({current_x + 1, current_y - 1}, {x, y}, Game.get_all_pieces(state), :downright)
  end

  def legal_move?({x, y}, {current_x, current_y}, state)
      when x - current_x < 0 and y - current_y < 0 and x - current_x == y - current_y do
    free_path?({current_x - 1, current_y - 1}, {x, y}, Game.get_all_pieces(state), :downleft)
  end

  # Any other move (e.g. knight special ones)
  def legal_move?(_, _, _), do: true

  # priv: helpers

  defp free_path?({x, y}, {x, y}, _pieces, _direction), do: true

  defp free_path?({x, y}, end_position, pieces, direction) do
    if Game.find_piece({x, y}, pieces),
      do: false,
      else: free_path?(next_position(x, y, direction), end_position, pieces, direction)
  end

  defp next_position(x, y, :right), do: {x + 1, y}
  defp next_position(x, y, :left), do: {x - 1, y}
  defp next_position(x, y, :up), do: {x, y + 1}
  defp next_position(x, y, :down), do: {x, y - 1}
  defp next_position(x, y, :upright), do: {x + 1, y + 1}
  defp next_position(x, y, :upleft), do: {x - 1, y + 1}
  defp next_position(x, y, :downright), do: {x + 1, y - 1}
  defp next_position(x, y, :downleft), do: {x - 1, y - 1}
end
