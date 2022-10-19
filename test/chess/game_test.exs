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
end
