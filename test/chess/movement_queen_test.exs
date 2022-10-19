defmodule Chess.MovementQueenTest do
  use ExUnit.Case

  alias Chess.Dashboard
  alias Chess.Movement
  alias Chess.Piece

  import Chess.TestHelper, only: [null_dashboard: 0]

  test "[queen] retrieve possible_movements default dashboard" do
    piece_pos = {0, 3}
    expected = []
    board = Dashboard.new()

    assert expected == Movement.possible_movements(board, piece_pos)
  end

  test "[queen] retrieve possible_movements, queen alone" do
    board = null_dashboard()
    piece = Piece.new(:queen)
    position = {3, 3}
    board = Dashboard.put(board, piece, position)

    expected = [
      {0, 3},
      {1, 3},
      {2, 3},
      {3, 0},
      {3, 1},
      {3, 2},
      {3, 4},
      {3, 5},
      {3, 6},
      {3, 7},
      {4, 3},
      {5, 3},
      {6, 3},
      {7, 3},
      {4, 4},
      {5, 5},
      {6, 6},
      {7, 7},
      {4, 2},
      {5, 1},
      {6, 0},
      {2, 4},
      {1, 5},
      {0, 6},
      {2, 2},
      {1, 1},
      {0, 0}
    ]

    assert expected == Movement.possible_movements(board, position)
  end
end
