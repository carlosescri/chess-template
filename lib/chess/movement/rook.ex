defmodule Chess.Movement.Rook do

  def movement_valid?(square_origin, square_final) do
    x_diff = elem(square_origin.coordinates, 0) - elem(square_final.coordinates, 0)
    y_diff = elem(square_origin.coordinates, 1) - elem(square_final.coordinates, 1)
    displacement = {x_diff, y_diff}
    check_movement(displacement)
  end

  defp check_movement(displacement) do
    case displacement do
      {0,0} -> false
      {_,0} -> true
      {0,_} -> true
      _ -> false
    end
  end
end
