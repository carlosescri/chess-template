defmodule Chess.MovementKnightTest do
  use ExUnit.Case

  alias Chess.Dashboard
  alias Chess.Movement
  alias Chess.Piece

  import Chess.TestHelper, only: [null_dashboard: 0]

  test "[knight] retrieve possible_movements default dashboard" do
    piece_pos = {0, 1}
    expected = [{2, 2}, {2, 0}]
    board = Dashboard.new()

    assert expected == Movement.possible_movements(board, piece_pos)
  end

  test "[knight] retrieve possible_movements, knight alone" do
    board = null_dashboard()
    piece = Piece.new(:knight)
    position = {3, 3}
    board = Dashboard.put(board, piece, position)

    expected = [{4, 5}, {4, 1}, {2, 5}, {2, 1}, {5, 4}, {1, 4}, {5, 2}, {1, 2}]

    assert expected == Movement.possible_movements(board, position)
  end
end
