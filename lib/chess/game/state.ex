defmodule Chess.Game.State do
  @moduledoc """
  Defines the struct that models a game state.
  """

  defstruct [
    :board,
    :white_player,
    :black_player,
    :white_turn?
  ]

  @type t :: %__MODULE__{
          board: list,
          white_player: binary,
          black_player: binary | nil,
          white_turn?: boolean
        }
end
