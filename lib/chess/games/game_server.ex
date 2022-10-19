defmodule Chess.Games.GameServer do
  @moduledoc """
  The Game schema.
  """
  alias Chess.Games
  alias Chess.Games.Game

  use GenServer


  @impl true
  def init(%{game_name: game_name}) do
    {:ok, Games.new(game_name)}
  end

  @doc """
  Starts the game.
  """
  def start_link(game_name) do
    GenServer.start_link(__MODULE__, %{game_name: game_name}, name: game_name)
  end

  def join_player(game_name) do
    GenServer.call(game_name, :join_player)
  end

  def get_pid(game_name) do
    GenServer.whereis(game_name)
  end

  def handle_call(:join_player, from, state) do
    {pid, _} = from

    case Games.join_player(pid, state) do
      {:ok, new_state} -> {:reply, {:ok, new_state}, new_state}
      {:error, message} -> {:reply, {:error, message}, state}
    end
  end
end
