defmodule Chess.Game.Board do
  @moduledoc """
  Board context
  """

  alias Chess.Game.Figure

  def move_figure(board, {from_row, from_col} = from, {to_row, to_col} = to) do
    figure = Map.get(board, from)

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
end
