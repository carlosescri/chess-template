defmodule Chess.Structs.Game do
  @moduledoc """
  Struct used for moving validation
  """
  @derive Jason.Encoder
  defstruct [
    :board,
    player_white: nil,
    player_black: nil
  ]

  @type t :: %__MODULE__{
          board: list,
          player_white: tuple,
          player_black: tuple
        }
end
