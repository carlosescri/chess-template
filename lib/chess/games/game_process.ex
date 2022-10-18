defmodule Chess.Games.GameProcess do
  @moduledoc """
  The Game schema.
  """

  use GenServer

  require Logger

  @impl true
  def init(game) do
    {:ok, game}
  end

  @doc """
  Starts the game.
  """
  @spec start_link(map) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(game) do
    GenServer.start_link(__MODULE__, name: game)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end
end
