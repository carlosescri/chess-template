defmodule Chess.Board do
  defstruct a1: "figure white rook",
            b1: "figure white knight",
            c1: "figure white bishop",
            d1: "figure white queen",
            e1: "figure white king",
            f1: "figure white bishop",
            g1: "figure white knight",
            h1: "figure white rook",
            a2: "figure white pawn",
            b2: "figure white pawn",
            c2: "figure white pawn",
            d2: "figure white pawn",
            e2: "figure white pawn",
            f2: "figure white pawn",
            g2: "figure white pawn",
            h2: "figure white pawn",
            a3: nil,
            b3: nil,
            c3: nil,
            d3: nil,
            e3: nil,
            f3: nil,
            g3: nil,
            h3: nil,
            a4: nil,
            b4: nil,
            c4: nil,
            d4: nil,
            e4: nil,
            f4: nil,
            g4: nil,
            h4: nil,
            a5: nil,
            b5: nil,
            c5: nil,
            d5: nil,
            e5: nil,
            f5: nil,
            g5: nil,
            h5: nil,
            a6: nil,
            b6: nil,
            c6: nil,
            d6: nil,
            e6: nil,
            f6: nil,
            g6: nil,
            h6: nil,
            a7: "figure black pawn",
            b7: "figure black pawn",
            c7: "figure black pawn",
            d7: "figure black pawn",
            e7: "figure black pawn",
            f7: "figure black pawn",
            g7: "figure black pawn",
            h7: "figure black pawn",
            a8: "figure black rook",
            b8: "figure black knight",
            c8: "figure black bishop",
            d8: "figure black queen",
            e8: "figure black king",
            f8: "figure black bishop",
            g8: "figure black knight",
            h8: "figure black rook"

  @num_conversion %{
    "a" => 1,
    "b" => 2,
    "c" => 3,
    "d" => 4,
    "e" => 5,
    "f" => 6,
    "g" => 7,
    "h" => 8
  }

  @letter_conversion %{
    1 => "a",
    2 => "b",
    3 => "c",
    4 => "d",
    5 => "e",
    6 => "f",
    7 => "g",
    8 => "h"
  }

  def from_square_to_position(square) do
    positions = String.graphemes(square)

    {@num_conversion[List.first(positions)], positions |> List.last() |> String.to_integer()}
  end

  def from_position_to_square(x, y) do
    Enum.join([@letter_conversion[x], y], "")
  end
end
