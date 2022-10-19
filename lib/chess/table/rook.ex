defmodule Chess.Table.Rook do
  def all_possible_moves(pieces, position, color) do
    moves = []

    moves
    |> up_straight_moves(pieces, position, color)
    |> right_moves(pieces, position, color)
    |> down_straight_moves(pieces, position, color)
    |> left_moves(pieces, position, color)
  end

  defp up_straight_moves(moves, pieces, position, color) do
    [column | [row | _]] = String.graphemes(position)
    {row, _} = Integer.parse(row)
    move_up_straight_one_step(pieces, column, row, moves, color)
  end

  defp move_up_straight_one_step(_pieces, _column, row, moves, _color) when row == 8 do
    moves
  end

  defp move_up_straight_one_step(pieces, column, row, moves, color) do
    row = row + 1
    position = "#{column}#{row}"
    blocked = Chess.Table.Board.is_there_an_own_piece?(pieces, position, color)
    oponent_field = Chess.Table.Board.is_there_an_oponent_piece?(pieces, position, color)

    cond do
      blocked -> moves
      oponent_field -> moves ++ [position]
      true -> move_up_straight_one_step(pieces, column, row, moves ++ [position], color)
    end
  end

  defp right_moves(moves, pieces, position, color) do
    [column | [row | _]] = String.graphemes(position)
    column_index = Enum.find_index(Chess.Table.EmptyBoard.x_axis(), fn x -> x == column end)
    move_right_one_step(pieces, column_index, row, moves, color)
  end

  defp move_right_one_step(_pieces, column_index, _row, moves, _color) when column_index == 7 do
    moves
  end

  defp move_right_one_step(pieces, column_index, row, moves, color) do
    column_index = column_index + 1
    column = Enum.at(Chess.Table.EmptyBoard.x_axis(), column_index)
    position = "#{column}#{row}"
    blocked = Chess.Table.Board.is_there_an_own_piece?(pieces, position, color)
    oponent_field = Chess.Table.Board.is_there_an_oponent_piece?(pieces, position, color)

    cond do
      blocked -> moves
      oponent_field -> moves ++ [position]
      true -> move_right_one_step(pieces, column_index, row, moves ++ [position], color)
    end
  end

  defp down_straight_moves(moves, pieces, position, color) do
    [column | [row | _]] = String.graphemes(position)
    {row, _} = Integer.parse(row)
    move_down_straight_one_step(pieces, column, row, moves, color)
  end

  defp move_down_straight_one_step(_pieces, _column, row, moves, _color) when row == 1 do
    moves
  end

  defp move_down_straight_one_step(pieces, column, row, moves, color) do
    row = row - 1
    position = "#{column}#{row}"
    blocked = Chess.Table.Board.is_there_an_own_piece?(pieces, position, color)
    oponent_field = Chess.Table.Board.is_there_an_oponent_piece?(pieces, position, color)

    cond do
      blocked -> moves
      oponent_field -> moves ++ [position]
      true -> move_down_straight_one_step(pieces, column, row, moves ++ [position], color)
    end
  end

  defp left_moves(moves, pieces, position, color) do
    [column | [row | _]] = String.graphemes(position)
    column_index = Enum.find_index(Chess.Table.EmptyBoard.x_axis(), fn x -> x == column end)
    move_left_one_step(pieces, column_index, row, moves, color)
  end

  defp move_left_one_step(_pieces, column_index, _row, moves, _color) when column_index == 0 do
    moves
  end

  defp move_left_one_step(pieces, column_index, row, moves, color) do
    column_index = column_index - 1
    column = Enum.at(Chess.Table.EmptyBoard.x_axis(), column_index)
    position = "#{column}#{row}"
    blocked = Chess.Table.Board.is_there_an_own_piece?(pieces, position, color)
    oponent_field = Chess.Table.Board.is_there_an_oponent_piece?(pieces, position, color)

    cond do
      blocked -> moves
      oponent_field -> moves ++ [position]
      true -> move_left_one_step(pieces, column_index, row, moves ++ [position], color)
    end
  end
end
