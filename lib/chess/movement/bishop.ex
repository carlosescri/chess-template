defmodule Chess.Movement.Bishop do

  def movement_valid?(square_origin, square_final) do
    x_diff = elem(square_origin.coordinates, 0) - elem(square_final.coordinates, 0)
    y_diff = elem(square_origin.coordinates, 1) - elem(square_final.coordinates, 1)

    displacement = {x_diff, y_diff}
    check_movement(displacement)
  end

  defp check_movement(displacement) do
    case displacement do
      {0,0} -> false
      {1,1} -> true
      {2,2} -> true
      {3,3} -> true
      {4,4} -> true
      {5,5} -> true
      {6,6} -> true
      {7,7} -> true
      {1,-1} -> true
      {2,-2} -> true
      {3,-3} -> true
      {4,-4} -> true
      {5,-5} -> true
      {6,-6} -> true
      {7,-7} -> true
      {-1,-1} -> true
      {-2,-2} -> true
      {-3,-3} -> true
      {-4,-4} -> true
      {-5,-5} -> true
      {-6,-6} -> true
      {-7,-7} -> true
      {-1,1} -> true
      {-2,2} -> true
      {-3,3} -> true
      {-4,4} -> true
      {-5,5} -> true
      {-6,6} -> true
      {-7,7} -> true
      _ -> false
    end
  end
end
