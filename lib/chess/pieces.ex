defmodule Chess.Pieces do
  @king "king"
  @queen "queen"
  @rook "rook"
  @knight "knight"
  @bishop "bishop"
  @pawn "pawn"

  @initial_position %{
    "A1" => {false, "r"},
    "A2" => {false, "kn"},
    "A3" => {false, "b"},
    "A4" => {false, "q"},
    "A5" => {false, "k"},
    "A6" => {false, "b"},
    "A7" => {false, "kn"},
    "A8" => {false, "r"},
    "B1" => {false, "p"},
    "B2" => {false, "p"},
    "B3" => {false, "p"},
    "B4" => {false, "p"},
    "B5" => {false, "p"},
    "B6" => {false, "p"},
    "B7" => {false, "p"},
    "B8" => {false, "p"},
    "H1" => {true, "r"},
    "H2" => {true, "kn"},
    "H3" => {true, "b"},
    "H4" => {true, "q"},
    "H5" => {true, "k"},
    "H6" => {true, "b"},
    "H7" => {true, "kn"},
    "H8" => {true, "r"},
    "G1" => {true, "p"},
    "G2" => {true, "p"},
    "G3" => {true, "p"},
    "G4" => {true, "p"},
    "G5" => {true, "p"},
    "G6" => {true, "p"},
    "G7" => {true, "p"},
    "G8" => {true, "p"},
  }

  def get_initial_position, do: @initial_position

end
