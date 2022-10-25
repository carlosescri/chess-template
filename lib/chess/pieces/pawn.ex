defmodule Chess.Pieces.Pawn do
  alias Chess.Board


  def can_move?(%{type: "pawn"} = piece, board, origin = {or_x, or_y}, target = {tar_x, tar_y}) do
    move_x = or_x - tar_x;
    move_y = or_y - tar_y;
    move = {move_x,move_y}

    IO.inspect(move, label: "IS this in ")
    valid_movements = movements(piece)
    IO.inspect(valid_movements, label: "valid_movements")

    Enum.member?(movements(piece), move)


    move_steps = Piece.generate_steps(move)
    IO.inspect(move_steps, label: "move_steps")
    #check if each any is blocked


  end

  defp movements(%{color: :black, first_move: true}), do: [{1,0}, {2,0}]
  defp movements(%{color: :black, first_move: false}), do: [{1,0}]
  defp movements(%{color: :white, first_move: true}), do: [{-1,0}, {-2,0}]
  defp movements(%{color: :white, first_move: false}), do: [{-1,0}]


  defp capture_movements do
    [
      {1,1}, {1,-1}, {-1,-1}, {-1,1}
    ]
  end

  defp is_path_blocked() do

  end


end
