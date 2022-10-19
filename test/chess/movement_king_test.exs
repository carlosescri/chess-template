defmodule Chess.MovementKingTest do
  use ExUnit.Case

  alias Chess.Dashboard
  alias Chess.Movement
  alias Chess.Piece

  import Chess.TestHelper, only: [null_dashboard: 0]

  test "[king] retrieve possible_movements default dashboard" do
    piece_pos = {0, 3}
    expected = []
    board = Dashboard.new()

    assert expected == Movement.possible_movements(board, piece_pos)
  end

  test "[king] retrieve possible_movements, king alone" do
    board = null_dashboard()
    piece = Piece.new(:king)
    position = {3, 3}
    board = Dashboard.put(board, piece, position)

    expected = [{4, 4}, {4, 2}, {2, 4}, {2, 2}, {4, 3}, {2, 3}, {3, 4}, {3, 2}]

    assert expected == Movement.possible_movements(board, position)
  end
end
