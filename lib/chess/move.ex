defmodule Chess.Move do
  alias Chess.Board
  alias Chess.State

  @kings ["figure white king", "figure black king"]

  def validate_move("figure white bishop", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)

    bishop_posibilities(from_x, from_y, to_x, to_y, board, turn, id)
  end

  def validate_move("figure black bishop", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)
    bishop_posibilities(from_x, from_y, to_x, to_y, board, turn, id)
  end

  def validate_move("figure white rook", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)

    rook_posibilities(from_x, from_y, to_x, to_y, board, turn, id)
  end

  def validate_move("figure black rook", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)
    rook_posibilities(from_x, from_y, to_x, to_y, board, turn, id)
  end

  def validate_move("figure white queen", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)

    queen_posibilities(from_x, from_y, to_x, to_y, board, turn, id)
  end

  def validate_move("figure black queen", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)
    queen_posibilities(from_x, from_y, to_x, to_y, board, turn, id)
  end

  def validate_move("figure black pawn", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)

    forward_pawn_posibility(from_x, from_y, to_x, to_y, 0, -1, board, turn, id) ++
      forward_pawn_posibility(from_x, from_y, to_x, to_y, 0, -2, board, turn, id)
  end

  def validate_move("figure white pawn", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)

    forward_pawn_posibility(from_x, from_y, to_x, to_y, 0, 1, board, turn, id) ++
      forward_pawn_posibility(from_x, from_y, to_x, to_y, 0, 2, board, turn, id)
  end

  def validate_move("figure white knight", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)

    forward_knight_posibility(from_x, from_y, to_x, to_y, 2, 1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -2, 1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -2, -1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 2, -1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -1, 2, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 1, 2, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -1, -2, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 1, -2, board, turn, id)
  end

  def validate_move("figure black knight", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)

    forward_knight_posibility(from_x, from_y, to_x, to_y, 2, 1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -2, 1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -2, -1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 2, -1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -1, 2, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 1, 2, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -1, -2, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 1, -2, board, turn, id)
  end

  def validate_move("figure black king", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)

    forward_knight_posibility(from_x, from_y, to_x, to_y, 1, 1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -1, 1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -1, -1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 1, -1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 1, 0, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -1, 0, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 0, -1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 0, 1, board, turn, id)
  end

  def validate_move("figure white king", from_square, to_square, board, turn, id) do
    {from_x, from_y} = Board.from_square_to_position(from_square)

    {to_x, to_y} = Board.from_square_to_position(to_square)

    forward_knight_posibility(from_x, from_y, to_x, to_y, 1, 1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -1, 1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -1, -1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 1, -1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 1, 0, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, -1, 0, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 0, -1, board, turn, id) ++
      forward_knight_posibility(from_x, from_y, to_x, to_y, 0, 1, board, turn, id)
  end

  def bishop_posibilities(from_x, from_y, to_x, to_y, board, turn, id) do
    posibilities(from_x, from_y, to_x, to_y, 1, -1, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, 1, 1, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, -1, -1, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, -1, 1, [], board, turn, id)
  end

  def queen_posibilities(from_x, from_y, to_x, to_y, board, turn, id) do
    posibilities(from_x, from_y, to_x, to_y, 1, -1, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, 1, 1, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, -1, -1, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, -1, 1, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, 1, 0, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, 0, 1, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, -1, 0, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, 0, -1, [], board, turn, id)
  end

  def rook_posibilities(from_x, from_y, to_x, to_y, board, turn, id) do
    posibilities(from_x, from_y, to_x, to_y, 1, 0, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, 0, 1, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, -1, 0, [], board, turn, id) ++
      posibilities(from_x, from_y, to_x, to_y, 0, -1, [], board, turn, id)
  end

  def posibilities(from_x, from_y, to_x, to_y, x, y, acc, board, turn, id) do
    next_x = from_x + x
    next_y = from_y + y

    if end_of_road?(next_x, next_y, to_x, to_y, board, turn, id) do
      acc
    else
      acc = acc ++ [{next_x, next_y}]
      posibilities(next_x, next_y, to_x, to_y, x, y, acc, board, turn, id)
    end
  end

  def forward_pawn_posibility(from_x, 2, to_x, to_y, x, y, board, turn, id)
      when abs(y) == 2 do
    next_x = from_x + x
    next_y = 2 + y

    if end_of_road?(next_x, next_y, to_x, to_y, board, turn, id) do
      []
    else
      [{next_x, next_y}]
    end
  end

  def forward_pawn_posibility(from_x, 7, to_x, to_y, x, y, board, turn, id)
      when abs(y) == 2 do
    next_x = from_x + x
    next_y = 7 + y

    if end_of_road?(next_x, next_y, to_x, to_y, board, turn, id) do
      []
    else
      [{next_x, next_y}]
    end
  end

  def forward_pawn_posibility(from_x, from_y, to_x, to_y, x, 1, board, turn, id) do
    next_x = from_x + x
    next_y = from_y + 1

    if end_of_road?(next_x, next_y, to_x, to_y, board, turn, id) do
      []
    else
      [{next_x, next_y}]
    end
  end

  def forward_pawn_posibility(from_x, from_y, to_x, to_y, x, -1, board, turn, id) do
    next_x = from_x + x
    next_y = from_y - 1

    if end_of_road?(next_x, next_y, to_x, to_y, board, turn, id) do
      []
    else
      [{next_x, next_y}]
    end
  end

  def forward_pawn_posibility(_, _, _, _, _, _, _, _, _), do: []

  def forward_knight_posibility(from_x, from_y, to_x, to_y, x, y, board, turn, id) do
    next_x = from_x + x
    next_y = from_y + y

    if end_of_road?(next_x, next_y, to_x, to_y, board, turn, id) do
      []
    else
      [{next_x, next_y}]
    end
  end

  def end_of_road?(-1, _, _, _, _, _, _), do: true
  def end_of_road?(_, -1, _, _, _, _, _), do: true
  def end_of_road?(0, _, _, _, _, _, _), do: true
  def end_of_road?(_, 0, _, _, _, _, _), do: true
  def end_of_road?(9, _, _, _, _, _, _), do: true
  def end_of_road?(_, 9, _, _, _, _, _), do: true
  def end_of_road?(10, _, _, _, _, _, _), do: true
  def end_of_road?(_, 10, _, _, _, _, _), do: true

  def end_of_road?(next_x, next_y, _, _, board, turn, id) do
    position = next_x |> Board.from_position_to_square(next_y) |> String.to_existing_atom()

    player =
      Map.get(board, position)
      |> then(&if not is_nil(&1), do: String.split(&1, " ") |> Enum.at(1), else: nil)

    eaten = eat_or_stop(Map.get(board, position), turn, player)

    if not eaten and Enum.member?(@kings, Map.get(board, position)) do
      player = Map.get(board, position) |> String.split(" ") |> Enum.at(1)
      State.won(%{won: player}, id)
      eaten
    else
      eaten
    end
  end

  defp eat_or_stop(figure, _, _) when is_nil(figure), do: false
  defp eat_or_stop(_figure, turn, player) when player != turn, do: false
  defp eat_or_stop(_figure, _turn, _player), do: true
end
