defmodule AllowedMovesTest do
  use ExUnit.Case

  alias ChessWeb.Moves

  describe "rook movements" do
    test "rook in D4 can move horizontally and vertically" do
      x = ["A4", "B4", "C4", "D1", "D2", "D3", "D5", "D6", "D7", "D8", "E4", "F4", "G4", "H4"]
      assert x == Moves.allowed_moves("rook", "D4")
    end

    test "rook in A1 can move horizontally and vertically" do
      x = ["A2", "A3", "A4", "A5", "A6", "A7", "A8", "B1", "C1", "D1", "E1", "F1", "G1", "H1"]
      assert x == Moves.allowed_moves("rook", "A1")
    end

    test "rook in E8 can move horizontally and vertically" do
      x = ["A8", "B8", "C8", "D8", "E1", "E2", "E3", "E4", "E5", "E6", "E7", "F8", "G8", "H8"]
      assert x == Moves.allowed_moves("rook", "E8")
    end

    test "rook in G6 can move horizontally and vertically" do
      x = ["A6", "B6", "C6", "D6", "E6", "F6", "G1", "G2", "G3", "G4", "G5", "G7", "G8", "H6"]
      assert x == Moves.allowed_moves("rook", "G6")
    end
  end

  describe "bishop movements" do
    test "bishop in D4 can move in four diagonals" do
      x = ["A1", "A7", "B2", "B6", "C3", "C5", "E3", "E5", "F2", "F6", "G1", "G7", "H8"]
      assert x == Moves.allowed_moves("bishop", "D4")
    end

    test "bishop in B1 has two diagonals available" do
      x = ["A2", "C2", "D3", "E4", "F5", "G6", "H7"]
      assert x == Moves.allowed_moves("bishop", "B1")
    end

    test "bishop in H8 has only one diagonal available" do
      x = ["A1", "B2", "C3", "D4", "E5", "F6", "G7"]
      assert x == Moves.allowed_moves("bishop", "H8")
    end
  end

  describe "queen movements" do
    test "queen in D4 can move in four diagonals and horizontally and vertically" do
      x = [
        "A1",
        "A4",
        "A7",
        "B2",
        "B4",
        "B6",
        "C3",
        "C4",
        "C5",
        "D1",
        "D2",
        "D3",
        "D5",
        "D6",
        "D7",
        "D8",
        "E3",
        "E4",
        "E5",
        "F2",
        "F4",
        "F6",
        "G1",
        "G4",
        "G7",
        "H4",
        "H8"
      ]

      assert x == Moves.allowed_moves("queen", "D4")
    end
  end
end
