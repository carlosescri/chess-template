defmodule Chess.GameServer do
  use GenServer

  alias Chess.Game

  # Client

  def start_link(game_name) do
    GenServer.start_link(__MODULE__, nil, name: game_name)
  end

  def join(game_name) do
    GenServer.call(game_name, :join)
  end

  def move(game_name, movement) do
    GenServer.call(game_name, {:move, movement})
  end

  # Server (callbacks)

  @impl true
  def init(nil) do
    {:ok, {Game.new(), %{}}}
  end

  @impl true
  def handle_call(:join, {pid, _}, {game, players}) when map_size(players) == 0 do
    {:reply, {:ok, game, :white}, {game, %{pid => :white}}}
  end

  def handle_call(:join, {pid, _}, {game, players}) when map_size(players) == 1 do
    {:reply, {:ok, game, :black}, {game, Map.put(players, pid, :black)}}
  end

  def handle_call(:join, _from, state) do
    {:reply, {:error, "This game is full. Try a new one."}, state}
  end

  @impl true
  def handle_call({:move, movement}, {pid, _}, {game, players} = state) do
    case Game.move(game, movement, players[pid]) do
      {:ok, new_game} ->
        Process.send(
          get_the_other_pid(pid, players),
          {:opponent_moved, new_game},
          []
        )

        {:reply, {:ok, new_game}, {new_game, players}}

      {:error, msg} ->
        {:reply, {:error, msg}, state}
    end
  end

  defp get_the_other_pid(pid, players) do
    players
    |> Map.keys()
    |> Kernel.--([pid])
    |> List.first()
  end
end
