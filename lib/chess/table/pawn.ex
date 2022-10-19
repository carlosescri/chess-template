defmodule Chess.Table.Pawn do

  def all_possible_moves(pieces, position, color) do
    [column | [row | _]] = String.graphemes position
    forward = moves_forward(pieces, column, row, color)
    captures = captures(pieces, column, row, color)
    forward ++ captures
  end

  def captures(pieces, column, row, color) do
    new_row = new_row(row, color)
    positions = new_columns column, new_row
    Enum.filter(positions, fn pos ->
      Chess.Table.Board.is_there_an_oponent_piece?(pieces, pos, color)
    end)
  end

  def moves_forward(pieces, column, row, :white) when row == "2" do
    next_row = new_row(row, :white)
    position = "#{column}#{next_row}"
    blocked = Chess.Table.Board.is_there_an_own_piece?(pieces, position, :white) || Chess.Table.Board.is_there_an_oponent_piece?(pieces, position, :white)
    if(blocked) do
      []
    else
      list = [position]
      next_row = new_row("#{next_row}", :white)
      position = "#{column}#{next_row}"
      blocked = Chess.Table.Board.is_there_an_own_piece?(pieces, position, :white) || Chess.Table.Board.is_there_an_oponent_piece?(pieces, position, :white)
      if(!blocked) do
        list ++ [position]
      else
        list
      end
    end
  end

  def moves_forward(pieces, column, row, :black) when row == "7" do
    next_row = new_row(row, :black)
    position = "#{column}#{next_row}"
    blocked = Chess.Table.Board.is_there_an_own_piece?(pieces, position, :black) || Chess.Table.Board.is_there_an_oponent_piece?(pieces, position, :black)
    if(blocked) do
      []
    else
      list = [position]
      next_row = new_row("#{next_row}", :black)
      position = "#{column}#{next_row}"
      blocked = Chess.Table.Board.is_there_an_own_piece?(pieces, position, :black) || Chess.Table.Board.is_there_an_oponent_piece?(pieces, position, :black)
      if(!blocked) do
        list ++ [position]
      else
        list
      end
    end
  end

  def moves_forward(pieces, column, row, color) do
    next_row = new_row(row, color)
    position = "#{column}#{next_row}"
    blocked = Chess.Table.Board.is_there_an_own_piece?(pieces, position, color) || Chess.Table.Board.is_there_an_oponent_piece?(pieces, position, color)
    if(blocked) do
      []
    else
      [position]
    end
  end

  defp new_row(row, color) do
    {new_row, _} = Integer.parse row
    case color do
      :white -> new_row + 1
      :black -> new_row - 1
    end
  end

  defp new_columns(column, row) do
    column_index = Enum.find_index Chess.Table.EmptyBoard.x_axis, fn x -> x == column end
    pos = position(column_index)
    Enum.map(pos, fn x ->
      new_column = Enum.at Chess.Table.EmptyBoard.x_axis, x
      "#{new_column}#{row}"
    end)
  end

  defp position(x) when x == 0 do [x + 1] end
  defp position(x) when x == 7 do [x - 1] end
  defp position(x) do [x + 1, x - 1] end
end
