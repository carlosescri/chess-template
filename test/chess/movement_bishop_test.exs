defmodule Chess.MovementBishopTest do
  use ExUnit.Case

  alias Chess.Dashboard
  alias Chess.Movement
  alias Chess.Piece

  import Chess.TestHelper, only: [null_dashboard: 0]

  test "[bishop] retrieve possible_movements default dashboard" do
    piece_pos = {0, 2}
    expected = []
    board = Dashboard.new()

    assert expected == Movement.possible_movements(board, piece_pos)
  end

  test "[bishop] retrieve possible_movements, bishop alone" do
    board = null_dashboard()
    piece = Piece.new(:bishop)
    position = {3, 3}
    board = Dashboard.put(board, piece, position)

    expected = [
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

  test "[bishop] retrieve possible_movements rock vs pawn " do
    piece = Piece.new(:bishop)
    position = {3, 3}

    piece2 = Piece.new(:pawn, :black)
    position2 = {5, 5}

    board =
      null_dashboard()
      |> Dashboard.put(piece, position)
      |> Dashboard.put(piece2, position2)

    expected = [
      {4, 4},
      {5, 5},
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
