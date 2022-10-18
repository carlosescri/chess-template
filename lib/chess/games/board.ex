defmodule Chess.Game.Board do
  @moduledoc """
  Board context
  """

  alias Chess.Game.Figure

  def move_figure(board, {from_row, from_col} = from, {to_row, to_col} = to) do
    figure = Map.get(board, from)

    :ok = validate_move(board, figure, from, to)

    board
    |> Map.put(to, figure)
    |> Map.delete(from)
  end

  def get_at(board, row, col) do
    Map.get(board, {row, col})
  end

  def default_board() do
    %{
      {0,0} => %Figure{type: :rook, color: :black},
      {0,1} => %Figure{type: :knight, color: :black},
      {0,2} => %Figure{type: :bishop, color: :black},
      {0,3} => %Figure{type: :queen, color: :black},
      {0,4} => %Figure{type: :king, color: :black},
      {0,5} => %Figure{type: :bishop, color: :black},
      {0,6} => %Figure{type: :knight, color: :black},
      {0,7} => %Figure{type: :rook, color: :black},
      {1,0} => %Figure{type: :pawn, color: :black},
      {1,1} => %Figure{type: :pawn, color: :black},
      {1,2} => %Figure{type: :pawn, color: :black},
      {1,3} => %Figure{type: :pawn, color: :black},
      {1,4} => %Figure{type: :pawn, color: :black},
      {1,5} => %Figure{type: :pawn, color: :black},
      {1,6} => %Figure{type: :pawn, color: :black},
      {1,7} => %Figure{type: :pawn, color: :black},
      {6,0} => %Figure{type: :pawn, color: :white},
      {6,1} => %Figure{type: :pawn, color: :white},
      {6,2} => %Figure{type: :pawn, color: :white},
      {6,3} => %Figure{type: :pawn, color: :white},
      {6,4} => %Figure{type: :pawn, color: :white},
      {6,5} => %Figure{type: :pawn, color: :white},
      {6,6} => %Figure{type: :pawn, color: :white},
      {6,7} => %Figure{type: :pawn, color: :white},
      {7,0} => %Figure{type: :rook, color: :white},
      {7,1} => %Figure{type: :knight, color: :white},
      {7,2} => %Figure{type: :bishop, color: :white},
      {7,3} => %Figure{type: :queen, color: :white},
      {7,4} => %Figure{type: :king, color: :white},
      {7,5} => %Figure{type: :bishop, color: :white},
      {7,6} => %Figure{type: :knight, color: :white},
      {7,7} => %Figure{type: :rook, color: :white}
    }
  end

  def validate_move(board, %Figure{type: :pawn, color: :white} = figure, from, to) do
    {from_row, from_col} = from
    {to_row, to_col} = to

    valid_moves = get_figure_valid_moves(figure)
    valid_moves_list = Enum.map(valid_moves, fn {x,y} -> "(#{x},#{y})" end)



    {move_row, move_col} = {to_row - from_row, to_col - from_col}

    # TODO: Comprobar el movimiento en el tablero y en la lista de valid_moves

#    Enum.map(valid, &is_valid_movements(board, &1, from, to))

    IO.puts("This figure can move to: #{IO.inspect(valid_moves_list)}")

    IO.puts("Validate WHITE PAWN move from (#{from_row},#{from_col}) to (#{to_row},#{to_col})")

    IO.puts("The move being checked is: (#{move_row},#{move_col})")

    :ok
  end

  def validate_move(_, _, _, _) do
    IO.puts("This figure has no validation yet")

    :ok
  end

  def get_figure_valid_moves(%Figure{type: :pawn, color: :white}) do
    [{-1, 0}, {-2, 0}, {-1, -1}, {-1, 1}]
  end

  def get_figure_valid_moves(_), do: []

  def check_move_in_board(board, valid_moves) do

  end
end
