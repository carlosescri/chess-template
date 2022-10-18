defmodule DiagonalMovementTest do
  use ExUnit.Case

  alias ChessWeb.Moves

  describe "diagonal movements" do
    test "moving diagonally to the top right from D4" do
      moves = ["D4", "E5", "F6", "G7", "H8"]
      assert moves == Enum.sort(Moves.top_right_diagonal([], "D4"))
    end

    test "moving diagonally to the top right from A8 is not available" do
      assert ["A8"] == Enum.sort(Moves.top_right_diagonal([], "A8"))
    end

    test "moving diagonally to the bottom right from D4" do
      moves = ["D4", "E3", "F2", "G1"]
      assert moves == Enum.sort(Moves.bottom_right_diagonal([], "D4"))
    end

    test "moving diagonally to the bottom right from H1 is not available" do
      assert ["H1"] == Enum.sort(Moves.bottom_right_diagonal([], "H1"))
    end

    test "moving diagonally to the bottom left from D4" do
      moves = ["A1", "B2", "C3", "D4"]
      assert moves == Enum.sort(Moves.bottom_left_diagonal([], "D4"))
    end

    test "moving diagonally to the bottom left from A1 is not available" do
      assert ["A1"] == Enum.sort(Moves.bottom_left_diagonal([], "A1"))
    end

    test "moving diagonally to the top left from D4" do
      moves = ["A7", "B6", "C5", "D4"]
      assert moves == Enum.sort(Moves.top_left_diagonal([], "D4"))
    end

    test "moving diagonally to the top left from B8 is not available" do
      assert ["B8"] == Enum.sort(Moves.top_left_diagonal([], "B8"))
    end
  end

  describe "jump movements (knight)" do
    test "knight in D4 can jump to several places" do
      places = [
        {"F", "5"},
        {"F", "3"},
        {"E", "6"},
        {"E", "2"},
        {"B", "5"},
        {"B", "3"},
        {"C", "6"},
        {"C", "2"}
      ]

      assert places == Moves.knight_moves({"D", "4"})
    end
  end

  test "knight in G7 has very few jumps available" do
    places = [{"H", "5"}, {"E", "8"}, {"E", "6"}, {"F", "5"}]
    assert places == Moves.knight_moves({"G", "7"})
  end
end
