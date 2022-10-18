defmodule Chess.Pieces do
  @king "king"
  @queen "queen"
  @rook "rook"
  @knight "knight"
  @bishop "bishop"
  @pawn "pawn"

  @initial_position %{
    "11" => {false, @rook},
    "12" => {false, @knight},
    "13" => {false, @bishop},
    "14" => {false, @queen},
    "15" => {false, @king},
    "16" => {false, @bishop},
    "17" => {false, @knight},
    "18" => {false, @rook},
    "21" => {false, @pawn},
    "22" => {false, @pawn},
    "23" => {false, @pawn},
    "24" => {false, @pawn},
    "25" => {false, @pawn},
    "26" => {false, @pawn},
    "27" => {false, @pawn},
    "28" => {false, @pawn},
    "71" => {true, @rook},
    "72" => {true, @knight},
    "73" => {true, @bishop},
    "74" => {true, @queen},
    "75" => {true, @king},
    "76" => {true, @bishop},
    "77" => {true, @knight},
    "78" => {true, @rook},
    "81" => {true, @pawn},
    "82" => {true, @pawn},
    "83" => {true, @pawn},
    "84" => {true, @pawn},
    "85" => {true, @pawn},
    "86" => {true, @pawn},
    "87" => {true, @pawn},
    "88" => {true, @pawn},
  }

  def get_initial_position, do: @initial_position

end
