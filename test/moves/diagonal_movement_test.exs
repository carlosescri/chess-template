defmodule DiagonalMovementTest do
  use ExUnit.Case

  alias ChessWeb.Moves

  test "moving diagonally to the top right from D4" do
    moves = ["D4", "E5", "F6", "G7", "H8"]
    assert moves == Enum.sort(Moves.top_right_diagonal([], "D4"))
  end

  test "moving diagonally to the top right from A8 has no more moves" do
    assert ["A8"] == Enum.sort(Moves.top_right_diagonal([], "A8"))
  end

  test "moving diagonally to the bottom right from D4" do
    moves = ["D4", "E3", "F2", "G1"]
    assert moves == Enum.sort(Moves.bottom_right_diagonal([], "D4"))
  end

  test "moving diagonally to the bottom right from H1 has no more moves" do
    assert ["H1"] == Enum.sort(Moves.bottom_right_diagonal([], "H1"))
  end

  test "moving diagonally to the bottom left from D4" do
    moves = ["A1", "B2", "C3", "D4"]
    assert moves == Enum.sort(Moves.bottom_left_diagonal([], "D4"))
  end

  test "moving diagonally to the bottom left from A1 has no more moves" do
    assert ["A1"] == Enum.sort(Moves.bottom_left_diagonal([], "A1"))
  end

  test "moving diagonally to the top left from D4" do
    moves = ["A7", "B6", "C5", "D4"]
    assert moves == Enum.sort(Moves.top_left_diagonal([], "D4"))
  end

  test "moving diagonally to the top left from B8 has no more moves" do
    assert ["B8"] == Enum.sort(Moves.top_left_diagonal([], "B8"))
  end
end
