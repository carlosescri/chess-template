defmodule Chess.Game.StateHandler do
  @moduledoc """
  Process that maintains the state of one game.
  """

  use GenServer

  alias Phoenix.PubSub

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_cast({:push_state, {game_id, new_state}}, _state) do
    # Notify state update
    PubSub.broadcast(Chess.PubSub, game_id, :game_state_updated)
    {:noreply, new_state}
  end
end
