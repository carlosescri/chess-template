defmodule Chess.Game do
  @moduledoc false
  defstruct [:name, :turn, :players, :board, state: "starting"]
end