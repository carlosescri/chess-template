defmodule Chess.Game.Figure do
  defstruct [
    :color,
    :type
  ]

  @type color() :: :white | :black
  @type figure_type() :: :rook | :knight | :bishop | :queen | :king | :pawn

  @type t() :: %__MODULE__{
          color: color,
          type: figure_type
        }
end
