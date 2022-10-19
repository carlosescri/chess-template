defmodule Chess.Structs.Figure do
  @moduledoc """
  Struct used for moving validation
  """
  @derive Jason.Encoder
  defstruct [
    # king | queen, etc.
    :type,
    # 0 infinite.
    steps: 0,
    # 0 everywhere
    direction: 0
  ]

  @type t :: %__MODULE__{
          type: binary,
          steps: non_neg_integer,
          direction: non_neg_integer
        }
end
