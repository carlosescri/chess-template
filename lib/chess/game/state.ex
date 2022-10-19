defmodule Chess.Game.State do
  @moduledoc """
  Defines the struct that models a game state.
  """

  defstruct [
    :board,
    :white_player,
    :black_player,
    game_state: :play_white
  ]

  @type game_state() ::
          :play_white
          | :play_white_check
          | :white_wins
          | :black_wins
          | :play_black
          | :play_black_check

  @type t() :: %__MODULE__{
          board: list,
          white_player: binary,
          black_player: binary | nil,
          game_state: game_state()
        }
end
