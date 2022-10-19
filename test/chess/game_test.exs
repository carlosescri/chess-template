defmodule GameTest do
  use ExUnit.Case

  setup do
    pieces = Chess.Table.Game.start
    %{pieces: pieces}
  end

  test "all pieces of game", %{pieces: pieces} do
    assert pieces == [
      %Chess.Table.Piece{name: :rook, position: "A1", color: :white, alive: true},
      %Chess.Table.Piece{name: :knight, position: "B1", color: :white, alive: true},
      %Chess.Table.Piece{name: :bishop, position: "C1", color: :white, alive: true},
      %Chess.Table.Piece{name: :queen, position: "D1", color: :white, alive: true},
      %Chess.Table.Piece{name: :king, position: "E1", color: :white, alive: true},
      %Chess.Table.Piece{name: :bishop, position: "F1", color: :white, alive: true},
      %Chess.Table.Piece{name: :knight, position: "G1", color: :white, alive: true},
      %Chess.Table.Piece{name: :rook, position: "H1", color: :white, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "A2", color: :white, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "B2", color: :white, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "C2", color: :white, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "D2", color: :white, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "E2", color: :white, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "F2", color: :white, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "G2", color: :white, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "H2", color: :white, alive: true},
      %Chess.Table.Piece{name: :rook, position: "A8", color: :black, alive: true},
      %Chess.Table.Piece{name: :knight, position: "B8", color: :black, alive: true},
      %Chess.Table.Piece{name: :bishop, position: "C8", color: :black, alive: true},
      %Chess.Table.Piece{name: :queen, position: "D8", color: :black, alive: true},
      %Chess.Table.Piece{name: :king, position: "E8", color: :black, alive: true},
      %Chess.Table.Piece{name: :bishop, position: "F8", color: :black, alive: true},
      %Chess.Table.Piece{name: :knight, position: "G8", color: :black, alive: true},
      %Chess.Table.Piece{name: :rook, position: "H8", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "A7", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "B7", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "C7", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "D7", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "E7", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "F7", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "G7", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "H7", color: :black, alive: true}
    ]
  end

  test "white pawn can move forward two steps", %{pieces: pieces} do
    moves = Chess.Table.Pawn.all_possible_moves(pieces, "A2", :white)
    assert moves === ["A3", "A4"]
  end

  test "white pawn can move forward only one step" do
    pieces = [
      %Chess.Table.Piece{name: :pawn, position: "B4", color: :white, alive: true},
    ]
    moves = Chess.Table.Pawn.all_possible_moves(pieces, "B2", :white)
    assert moves === ["B3"]
  end

  test "white pawn can capture" do
    pieces = [
      %Chess.Table.Piece{name: :pawn, position: "A7", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "B7", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "C7", color: :black, alive: true},
    ]
    moves = Chess.Table.Pawn.all_possible_moves(pieces, "B6", :white)
    assert Enum.sort(moves) == ["A7", "C7"]
  end

  test "black pawn can move forward only one step" do
    pieces = [
      %Chess.Table.Piece{name: :pawn, position: "B5", color: :white, alive: true},
    ]
    moves = Chess.Table.Pawn.all_possible_moves(pieces, "B7", :black)
    assert moves === ["B6"]
  end

  test "black pawn can move forward two steps", %{pieces: pieces} do
    moves = Chess.Table.Pawn.all_possible_moves(pieces, "A7", :black)
    assert moves === ["A6", "A5"]
  end

  test "black pawn can capture" do
    pieces = [
      %Chess.Table.Piece{name: :pawn, position: "A2", color: :white, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "B2", color: :white, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "C2", color: :white, alive: true},
    ]
    moves = Chess.Table.Pawn.all_possible_moves(pieces, "B3", :black)
    assert Enum.sort(moves) == ["A2", "C2"]
  end

  test "white rook can move forward and right" do
    pieces = []
    moves = Chess.Table.Rook.all_possible_moves(pieces, "A1", :white)
    assert Enum.sort(moves) == ["A2", "A3", "A4", "A5", "A6", "A7", "A8", "B1", "C1", "D1", "E1", "F1", "G1", "H1"]
  end

  test "white rook can move forward but is blocked in A5" do
    pieces = [
      %Chess.Table.Piece{name: :pawn, position: "A5", color: :white, alive: true},
    ]
    moves = Chess.Table.Rook.all_possible_moves(pieces, "A1", :white)
    assert Enum.sort(moves) == ["A2", "A3", "A4", "B1", "C1", "D1", "E1", "F1", "G1", "H1"]
  end

  test "white rook can move right but is blocked in E1" do
    pieces = [
      %Chess.Table.Piece{name: :pawn, position: "E1", color: :white, alive: true}
    ]
    moves = Chess.Table.Rook.all_possible_moves(pieces, "A1", :white)
    assert Enum.sort(moves) == ["A2", "A3", "A4", "A5", "A6", "A7", "A8", "B1", "C1", "D1"]
  end

  test "black rook can move down and right" do
    pieces = []
    moves = Chess.Table.Rook.all_possible_moves(pieces, "A8", :black)
    assert Enum.sort(moves) == ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "B8", "C8", "D8", "E8", "F8", "G8", "H8"]
  end

  test "black rook can move down but is blocked in A5" do
    pieces = [
      %Chess.Table.Piece{name: :pawn, position: "A5", color: :black, alive: true}
    ]
    moves = Chess.Table.Rook.all_possible_moves(pieces, "A8", :black)
    assert Enum.sort(moves) == ["A6", "A7", "B8", "C8", "D8", "E8", "F8", "G8", "H8"]
  end

  test "black rook can move right but is blocked in E8" do
    pieces = [
      %Chess.Table.Piece{name: :pawn, position: "E8", color: :black, alive: true}
    ]
    moves = Chess.Table.Rook.all_possible_moves(pieces, "A8", :black)
    assert Enum.sort(moves) == ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "B8", "C8", "D8"]
  end

  test "black rook can move down and left and right" do
    pieces = []
    moves = Chess.Table.Rook.all_possible_moves(pieces, "D8", :black)
    assert Enum.sort(moves) == ["A8", "B8", "C8", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "E8", "F8", "G8", "H8"]
  end

  test "white rook can move right but oponent is in A5" do
    pieces = [
      %Chess.Table.Piece{name: :pawn, position: "A5", color: :black, alive: true}
    ]
    moves = Chess.Table.Rook.all_possible_moves(pieces, "A1", :white)
    assert Enum.sort(moves) == ["A2", "A3", "A4", "A5", "B1", "C1", "D1", "E1", "F1", "G1", "H1"]
  end

  test "white rook can move right but oponent is in A5 and D1" do
    pieces = [
      %Chess.Table.Piece{name: :pawn, position: "A5", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "D1", color: :black, alive: true}
    ]
    moves = Chess.Table.Rook.all_possible_moves(pieces, "A1", :white)
    assert Enum.sort(moves) == ["A2", "A3", "A4", "A5", "B1", "C1", "D1"]
  end

  test "white rook is in D3 and is blocked in D2 and oponent is in D6 and F3" do
    pieces = [
      %Chess.Table.Piece{name: :pawn, position: "D2", color: :white, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "D6", color: :black, alive: true},
      %Chess.Table.Piece{name: :pawn, position: "F3", color: :black, alive: true}
    ]
    moves = Chess.Table.Rook.all_possible_moves(pieces, "D3", :white)
    assert Enum.sort(moves) == ["A3", "B3", "C3", "D4", "D5", "D6", "E3", "F3"]
  end
end
