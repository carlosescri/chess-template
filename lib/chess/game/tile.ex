defmodule Chess.Game.Tile do
  @moduledoc """
  Struct defining a board tile
  """

  alias Chess.Game.Figure

  defstruct [
    :figure,
    selected: false
  ]

  @type t() :: %__MODULE__{
          figure: Figure.t() | nil,
          selected: boolean
        }
end
