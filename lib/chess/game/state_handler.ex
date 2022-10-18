defmodule Chess.Game.StateHandler do
  @moduledoc """
  Process that maintains the state of one game.
  """

  use GenServer

  alias Chess.Game.State

  @spec init(State.t()) :: {:ok, State.t()}
  def init(state) do
    {:ok, state}
  end
end
