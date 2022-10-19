defmodule Chess.GameServer do
  use GenServer
  alias Chess.Game

  # CLIENT FUNCTIONS
  def start_link(game_name) do
    GenServer.start_link(__MODULE__, nil, name: game_name)
  end

  def join(game_name) do
    GenServer.call(game_name, :join)
  end

  # SERVER FUNCTIONS
  def init(_) do
    {:ok, Game.new()}
  end

  def handle_call(:join, from, state) do
    {pid, _} = from

    case Game.join(pid, state) do
      {:ok, new_state} -> {:reply, {:ok, new_state}, new_state}
      {:error, message} -> {:reply, {:error, message}, state}
    end
  end
end
