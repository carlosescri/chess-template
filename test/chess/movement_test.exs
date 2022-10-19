defmodule Chess.MovementTest do
  use ExUnit.Case

  alias Chess.Dashboard
  alias Chess.Movement

  test "[pawn] retrieve possible_movements" do
    expected = [{2, 0}]
    board = Dashboard.new()

    assert expected == Movement.possible_movements(board, {1, 0})
  end
end
