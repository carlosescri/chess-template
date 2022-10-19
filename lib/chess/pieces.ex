defmodule Chess.Pieces do
  @moduledoc """
  This module contains constants about the name of the pieces and their
  initial position.

  This functions are used by the GameLive liveview.
  """

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
    "71" => {true, @pawn},
    "72" => {true, @pawn},
    "73" => {true, @pawn},
    "74" => {true, @pawn},
    "75" => {true, @pawn},
    "76" => {true, @pawn},
    "77" => {true, @pawn},
    "78" => {true, @pawn},
    "81" => {true, @rook},
    "82" => {true, @knight},
    "83" => {true, @bishop},
    "84" => {true, @queen},
    "85" => {true, @king},
    "86" => {true, @bishop},
    "87" => {true, @knight},
    "88" => {true, @rook},
  }

  def get_initial_position, do: @initial_position

end
