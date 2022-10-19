defmodule Chess.Movements do
  @board_length 8

  defguard is_inside_board(x, y) when x < @board_length and y < @board_length

  defguard is_diagonal_movement(actual_x, actual_y, x, y)
           when abs(actual_x - x) == abs(actual_y - y)

  def movement(cells, piece, actual_position, {x, y} = new_position) when is_inside_board(x, y),
    do: piece_movement(cells, piece, actual_position, new_position)

  def movement(_, _, _, _), do: :error

  # One position movement in any direction
  defp piece_movement(cells, %{type: :king, color: color}, {actual_x, y}, {x, y})
       when abs(actual_x - x) == 1 and actual_x < x,
       do:
         check_next_position(
           cells,
           color,
           {actual_x + 1, y},
           {1, 0},
           get_movements_number(actual_x, x)
         )

  defp piece_movement(cells, %{type: :king, color: color}, {actual_x, y}, {x, y})
       when abs(actual_x - x) == 1 and actual_x > x,
       do:
         check_next_position(
           cells,
           color,
           {actual_x - 1, y},
           {-1, 0},
           get_movements_number(actual_x, x)
         )

  defp piece_movement(cells, %{type: :king, color: color}, {x, actual_y}, {x, y})
       when abs(actual_y - y) == 1 and actual_y < y,
       do:
         check_next_position(
           cells,
           color,
           {x, actual_y + 1},
           {0, 1},
           get_movements_number(actual_y, y)
         )

  defp piece_movement(cells, %{type: :king, color: color}, {x, actual_y}, {x, y})
       when abs(actual_y - y) == 1 and actual_y > y,
       do:
         check_next_position(
           cells,
           color,
           {x, actual_y - 1},
           {0, -1},
           get_movements_number(actual_y, y)
         )

  defp piece_movement(_, %{type: :king}, _, _), do: :error

  # Lineal movement for queen
  defp piece_movement(cells, %{type: :queen, color: color}, {actual_x, y}, {x, y})
       when actual_x < x,
       do:
         check_next_position(
           cells,
           color,
           {actual_x + 1, y},
           {1, 0},
           get_movements_number(actual_x, x)
         )

  defp piece_movement(cells, %{type: :queen, color: color}, {actual_x, y}, {x, y})
       when actual_x > x,
       do:
         check_next_position(
           cells,
           color,
           {actual_x - 1, y},
           {-1, 0},
           get_movements_number(actual_x, x)
         )

  defp piece_movement(cells, %{type: :queen, color: color}, {x, actual_y}, {x, y})
       when actual_y < y,
       do:
         check_next_position(
           cells,
           color,
           {x, actual_y + 1},
           {0, 1},
           get_movements_number(actual_y, y)
         )

  defp piece_movement(cells, %{type: :queen, color: color}, {x, actual_y}, {x, y})
       when actual_y > y,
       do:
         check_next_position(
           cells,
           color,
           {x, actual_y - 1},
           {0, -1},
           get_movements_number(actual_y, y)
         )

  # Diagonal movement for queen
  defp piece_movement(cells, %{type: :queen, color: color}, {actual_x, actual_y}, {x, y})
       when is_diagonal_movement(actual_x, actual_y, x, y) and actual_x < x and actual_y > y,
       do:
         check_next_position(
           cells,
           color,
           {actual_x + 1, actual_y - 1},
           {1, -1},
           get_movements_number(actual_x, x)
         )

  defp piece_movement(cells, %{type: :queen, color: color}, {actual_x, actual_y}, {x, y})
       when is_diagonal_movement(actual_x, actual_y, x, y) and actual_x > x and actual_y < y,
       do:
         check_next_position(
           cells,
           color,
           {actual_x - 1, actual_y + 1},
           {-1, 1},
           get_movements_number(actual_x, x)
         )

  defp piece_movement(cells, %{type: :queen, color: color}, {actual_x, actual_y}, {x, y})
       when is_diagonal_movement(actual_x, actual_y, x, y) and actual_x < x and actual_y < y,
       do:
         check_next_position(
           cells,
           color,
           {actual_x - 1, actual_y - 1},
           {-1, -1},
           get_movements_number(actual_x, x)
         )

  defp piece_movement(cells, %{type: :queen, color: color}, {actual_x, actual_y}, {x, y})
       when is_diagonal_movement(actual_x, actual_y, x, y) and actual_x > x and actual_y > y,
       do:
         check_next_position(
           cells,
           color,
           {actual_x + 1, actual_y + 1},
           {1, 1},
           get_movements_number(actual_x, x)
         )

  defp piece_movement(_, %{type: :queen}, _, _), do: :error

  defp piece_movement(_, _, _, _), do: {:ok, nil}

  defp check_next_position(cells, color, {x, y} = position, {increment_x, increment_y}, n)
       when n > 0 do
    case position_availability(color, Map.get(cells, position)) do
      {:ok, nil} ->
        check_next_position(
          cells,
          color,
          {x + increment_x, y + increment_y},
          {increment_x, increment_y},
          n - 1
        )

      _ ->
        :error
    end
  end

  defp check_next_position(cells, color, position, _, 0),
    do: position_availability(color, Map.get(cells, position))

  defp position_availability(_, nil), do: {:ok, nil}

  defp position_availability(color, %{color: occupied_color}) when occupied_color == color,
    do: :error

  defp position_availability(color, %{color: occupied_color} = piece)
       when occupied_color != color,
       do: {:ok, piece}

  defp get_movements_number(initial, final), do: abs(initial - final) - 1
end
