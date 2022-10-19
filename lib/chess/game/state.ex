defmodule Chess.Game.State do
  @moduledoc """
  Defines the struct that models a game state.
  """

  alias Chess.Game.Figure

  defstruct [
    :board,
    :white_player,
    :black_player,
    :turn
  ]

  @type t :: %__MODULE__{
          board: list,
          white_player: binary,
          black_player: binary | nil,
          turn: Figure.color()
        }
end
