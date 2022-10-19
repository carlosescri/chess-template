defmodule Chess.State do
  use Agent

  alias Phoenix.PubSub

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def won(%{won: won}, topic) do
    state = Map.get(value(), topic)
    state = Map.put(state, :won, won)
    Agent.update(__MODULE__, &Map.put(&1, topic, state))
    make_change(state, topic)
  end

  def set(state, topic) do
    Agent.update(__MODULE__, &Map.put(&1, topic, state))
    make_change(state, topic)
  end

  defp make_change(state, topic) do
    PubSub.broadcast(Chess.PubSub, topic, {:state, state})
    {:reply, state}
  end
end
