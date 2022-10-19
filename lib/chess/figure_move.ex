defmodule Chess.FigureMove do

  @rows [1, 2, 3, 4 ,5 ,6 ,7, 8]

  @columns [1, 2, 3, 4 ,5 ,6 ,7, 8]
  @columns_value %{ "a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8}

  def move(%{"cor" => cor, "player" => "white", "figure" => "pawn"}) do
    [column, row] = String.codepoints(cor)
    row = String.to_integer(row)
    moves = Enum.filter(@columns, fn y -> row > y  end)

    total_move = case length(moves) == 6 do
      true -> [ row - 1 , row - 2]
      false -> [ row - 1 ]
    end

    Enum.map(total_move, fn move -> column <> "#{move}" end)
  end

  def move(%{"cor" => cor, "player" => "black", "figure" => "pawn"}) do
    [column, row] = String.codepoints(cor)
    row = String.to_integer(row)
    moves = Enum.filter(@columns, fn y -> row < y  end)

    total_move = case length(moves) == 6 do
      true -> [ row + 1 , row + 2]
      false -> [ row + 1 ]
    end

    Enum.map(total_move, fn move -> column <> "#{move}" end)
  end

  def kill?(%{"cor" => cor, "figure" => "pawn", "player" => player} = params, coordinate, active_player) do
    [column_kill, row_kill] = String.codepoints(cor)
    row_kill = String.to_integer(row_kill)

    figure = Atom.to_string(coordinate)

    [column, row] = String.codepoints(figure)

    row_left = String.to_integer(row) + 1
    row_right = String.to_integer(row) - 1

    column_value = Map.get(@columns_value, column)
    column_kill_value = Map.get(@columns_value, column_kill)

    column_left = column_value - 1
    column_right = column_value + 1

    (row_left == row_kill or row_right == row_kill) and (column_left == column_kill_value or column_right == column_kill_value) and player != active_player
  end
end
