defmodule Chess.Game.StateHandler do
  @moduledoc """
  Process that maintains the state of one game.
  """

  use GenServer

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end
