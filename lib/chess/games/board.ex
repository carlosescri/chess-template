defmodule Chess.Game.Board do
  @moduledoc """
  Board context
  """
  require Logger

  alias Chess.Game.Figure

  def move_figure(board, {from_row, from_col} = from, {to_row, to_col} = to) do
    figure = Map.get(board, from)

    IO.inspect(figure)

    case validate_move(board, figure, from, to) do
      :ok ->
        board
        |> Map.put(to, figure)
        |> Map.delete(from)

      :error ->
        Logger.error("Can not move figure to position.")
        board
    end
  end

  def get_at(board, row, col) do
    Map.get(board, {row, col})
  end

  def default_board() do
    %{
      {0, 0} => %Figure{type: :rook, color: :black},
      {0, 1} => %Figure{type: :knight, color: :black},
      {0, 2} => %Figure{type: :bishop, color: :black},
      {0, 3} => %Figure{type: :queen, color: :black},
      {0, 4} => %Figure{type: :king, color: :black},
      {0, 5} => %Figure{type: :bishop, color: :black},
      {0, 6} => %Figure{type: :knight, color: :black},
      {0, 7} => %Figure{type: :rook, color: :black},
      {1, 0} => %Figure{type: :pawn, color: :black},
      {1, 1} => %Figure{type: :pawn, color: :black},
      {1, 2} => %Figure{type: :pawn, color: :black},
      {1, 3} => %Figure{type: :pawn, color: :black},
      {1, 4} => %Figure{type: :pawn, color: :black},
      {1, 5} => %Figure{type: :pawn, color: :black},
      {1, 6} => %Figure{type: :pawn, color: :black},
      {1, 7} => %Figure{type: :pawn, color: :black},
      {6, 0} => %Figure{type: :pawn, color: :white},
      {6, 1} => %Figure{type: :pawn, color: :white},
      {6, 2} => %Figure{type: :pawn, color: :white},
      {6, 3} => %Figure{type: :pawn, color: :white},
      {6, 4} => %Figure{type: :pawn, color: :white},
      {6, 5} => %Figure{type: :pawn, color: :white},
      {6, 6} => %Figure{type: :pawn, color: :white},
      {6, 7} => %Figure{type: :pawn, color: :white},
      {7, 0} => %Figure{type: :rook, color: :white},
      {7, 1} => %Figure{type: :knight, color: :white},
      {7, 2} => %Figure{type: :bishop, color: :white},
      {7, 3} => %Figure{type: :queen, color: :white},
      {7, 4} => %Figure{type: :king, color: :white},
      {7, 5} => %Figure{type: :bishop, color: :white},
      {7, 6} => %Figure{type: :knight, color: :white},
      {7, 7} => %Figure{type: :rook, color: :white}
    }
  end

  def validate_move(board, %Figure{color: moving_color} = figure, from, to) do
    {from_row, from_col} = from
    {to_row, to_col} = to

    valid_moves = Figure.valid_moves(figure)
    valid_moves_list = Enum.map(valid_moves, fn {x, y} -> "(#{x},#{y})" end)

    current_move = {move_row, move_col} = {to_row - from_row, to_col - from_col}
    # TODO: Comprobar el movimiento en el tablero y en la lista de valid_moves

    is_legal? = current_move in valid_moves
    IO.puts("Moving a '#{}' figure.")
    IO.puts("This figure can move to: #{IO.inspect(valid_moves_list)}")
    IO.puts("Validate move from (#{from_row},#{from_col}) to (#{to_row},#{to_col})")
    IO.puts("The move being checked is: (#{move_row},#{move_col})")

    case {is_legal?, Map.get(board, to, nil)} do
      {false, _} -> :error
      {_, %Figure{color: :white}} when moving_color == :black -> :ok
      {_, %Figure{color: :white}} when moving_color == :white -> :error
      {_, %Figure{color: :black}} when moving_color == :white -> :ok
      {_, %Figure{color: :black}} when moving_color == :black -> :error
      {_, nil} -> :ok
      _ -> :error
    end
  end

  def validate_move(_, _, _, _) do
    IO.puts("This figure has no validation yet")

    :ok
  end

  def check_move_in_board(board, valid_moves) do
  end
end
