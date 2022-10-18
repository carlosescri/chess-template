defmodule Chess.Games.Game do
  @moduledoc """
  The Game schema.
  """

  defstruct [
    :game_name,
    :start_date,
    :finish_date,
    :winner,
    :white_player,
    :black_player,
    :player_turn,
    :dashboard
  ]

  @type player :: %{pieces: [], pid: term(), name: binary}

  @type t :: %__MODULE__{
          game_name: binary,
          start_date: NaiveDateTime.t() | nil,
          finish_date: NaiveDateTime.t() | nil,
          winner: binary | nil,
          white_player: binary | nil,
          black_player: binary | nil,
          player_turn: nil | :white | :black,
          dashboard: list
        }
end
