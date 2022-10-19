defmodule Chess.FigureMove do

  @rows [1, 2, 3, 4 ,5 ,6 ,7, 8]

  @columns [1, 2, 3, 4 ,5 ,6 ,7, 8]
  @columns_value %{ "a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8 }
  @columns_key %{ 1 => "a", 2 => "b", 3 => "c", 4 => "d", 5 => "e", 6 => "f", 7 => "g", 8 => "h" }

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

  def move(%{"cor" => cor, "player" => player, "figure" => "rook"}) do
    [x, y] = String.codepoints(cor)
    move_x_y(x, y)
  end

  def kill?(%{"cor" => cor, "player" => player} = params, coordinate, active_player, _move, {_color, "pawn"}) do
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

  def kill?(%{"cor" => cor, "player" => player} = params, _coordinate, active_player, move, {_color, "rook"}) do
    Enum.member?(move, cor) and player != active_player
  end

  defp move_x_y(x,y) do
    x_value = Map.get(@columns_value, x)
    y = String.to_integer(y)

    x_left = Enum.filter(@columns, fn column -> x_value < column  end)
    x_right = Enum.filter(@columns, fn column -> x_value >  column  end)

    x_left = Enum.map(x_left, fn x_number -> Map.get(@columns_key, x_number) end)
    x_right = Enum.map(x_right, fn x_number -> Map.get(@columns_key, x_number) end)

    move_in_x = x_left ++ x_right

    y_up = Enum.filter(@rows, fn row -> row < y  end)
    y_down = Enum.filter(@rows, fn row -> row >  y  end)

    move_in_y = y_up ++ y_down

    move_in_x = Enum.map(move_in_x, fn move -> move <> "#{y}" end)
    move_in_y = Enum.map(move_in_y, fn move -> x <> "#{move}" end)

    move_in_x ++ move_in_y
  end
end
