defmodule Chess.Game.Tile do
  @moduledoc """
  Struct defining a board tile
  """

  alias Chess.Game.Figure

  defstruct [
    :figure,
    :coordinates,
    selected: false
  ]

  @type t() :: %__MODULE__{
          figure: Figure.t() | nil,
          selected: boolean,
          coordinates: tuple
        }
end
