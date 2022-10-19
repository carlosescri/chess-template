defmodule Chess.MovementRookTest do
  use ExUnit.Case

  alias Chess.Dashboard
  alias Chess.Movement
  alias Chess.Piece

  import Chess.TestHelper, only: [null_dashboard: 0]

  test "[rook] retrieve possible_movements default dashboard" do
    piece_pos = {0, 0}
    expected = []
    board = Dashboard.new()

    assert expected == Movement.possible_movements(board, piece_pos)
  end

  test "[rook] retrieve possible_movements, rook alone" do
    board = null_dashboard()
    piece = Piece.new(:rook)
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
      {7, 3}
    ]

    assert expected == Movement.possible_movements(board, position)
  end

  test "[rook] retrieve possible_movements rock vs pawn " do
    piece = Piece.new(:rook)
    position = {3, 3}

    piece2 = Piece.new(:pawn, :black)
    position2 = {3, 5}

    board =
      null_dashboard()
      |> Dashboard.put(piece, position)
      |> Dashboard.put(piece2, position2)

    expected = [
      {0, 3},
      {1, 3},
      {2, 3},
      {3, 0},
      {3, 1},
      {3, 2},
      {3, 4},
      {3, 5},
      {4, 3},
      {5, 3},
      {6, 3},
      {7, 3}
    ]

    assert expected == Movement.possible_movements(board, position)
  end

  test "[rook] retrieve possible_movements empty board, rook in edge" do
    piece = Piece.new(:rook)
    position = {7, 7}

    piece2 = Piece.new(:pawn, :black)
    position2 = {7, 5}

    board =
      null_dashboard()
      |> Dashboard.put(piece, position)
      |> Dashboard.put(piece2, position2)

    expected = [{0, 7}, {1, 7}, {2, 7}, {3, 7}, {4, 7}, {5, 7}, {6, 7}, {7, 5}, {7, 6}]

    assert expected == Movement.possible_movements(board, position)
  end
end
