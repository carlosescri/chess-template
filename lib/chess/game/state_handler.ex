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
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_cast({:push_state, new_state}, _state) do
    {:noreply, new_state}
  end
end
