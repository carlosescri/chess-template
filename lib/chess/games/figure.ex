defmodule Chess.Game.Figure do

  @type figure() :: :pawn | :rook | :knight | :bishop | :queen | :king
  @type color() :: :black | :white

  defstruct color: nil,
            type: nil

  @type t :: %__MODULE__{
          color: color,
          type: figure
        }
end
