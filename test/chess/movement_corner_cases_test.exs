defmodule Chess.MovementCornerCasesTest do
  use ExUnit.Case

  alias Chess.Dashboard
  alias Chess.Movement
  alias Chess.Piece

  import Chess.TestHelper, only: [null_dashboard: 0]

  test "check restrict movements all kind of pieces" do
    inputs = [
      :queen,
      :rook,
      :bishop,
      :knight
    ]

    expecteds = [
      [{2, 4}, {3, 4}, {4, 4}, {5, 4}],
      [{2, 4}, {3, 4}, {4, 4}, {5, 4}],
      [],
      []
    ]

    inputs
    |> Enum.zip(expecteds)
    |> Enum.each(fn {piece_type, expected} ->
      piece = Piece.new(piece_type)
      king = Piece.new(:king)

      rook = Piece.new(:rook, :black)
      pawn = Piece.new(:pawn, :black)

      piece_pos = {6, 4}

      board =
        null_dashboard()
        |> Dashboard.put(king, {7, 4})
        |> Dashboard.put(piece, piece_pos)
        |> Dashboard.put(rook, {2, 4})
        |> Dashboard.put(pawn, {1, 5})

      assert expected == Movement.possible_movements(board, piece_pos)
    end)
  end

  test "check restrict movements pawn" do
    king = Piece.new(:king)
    piece = Piece.new(:pawn)
    bishop = Piece.new(:bishop, :black)
    pawn = Piece.new(:pawn, :black)
    piece_pos = {6, 5}

    board =
      null_dashboard()
      |> Dashboard.put(king, {7, 4})
      |> Dashboard.put(piece, piece_pos)
      |> Dashboard.put(bishop, {4, 7})
      |> Dashboard.put(pawn, {1, 5})

    expected = []

    assert expected == Movement.possible_movements(board, piece_pos)
  end

  test "check restrict movements king" do
    king = Piece.new(:king)
    pawn = Piece.new(:pawn)
    rook = Piece.new(:rook, :black)

    piece_pos = {7, 7}

    board =
      null_dashboard()
      |> Dashboard.put(king, piece_pos)
      |> Dashboard.put(rook, {0, 6})
      |> Dashboard.put(pawn, {6, 7})

    expected = []

    assert expected == Movement.possible_movements(board, piece_pos)
  end

  test "is checkmate" do
    player = :white

    board =
      null_dashboard()
      |> Dashboard.put(Piece.new(:king), {7, 7})
      |> Dashboard.put(Piece.new(:rook, :black), {1, 7})
      |> Dashboard.put(Piece.new(:rook, :black), {1, 6})

    assert Movement.checkmate?(board, player)
  end
end
