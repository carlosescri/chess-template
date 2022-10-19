defmodule Chess.GameServer do
  use GenServer

  alias Chess.GameState
  alias Chess.Player

  def child_spec(game_name) do
    %{
      id: GameServer,
      start: {GameServer, :start_link, [game_name]},
      restart: :transient
    }
  end

  def start_link(game_name) do
    GenServer.start_link(__MODULE__, game_name, name: __MODULE__)
  end

  def name(game_pid) do
    state(game_pid) |> Map.get(:name)
  end

  def status(game_pid) do
    state(game_pid) |> Map.get(:status)
  end

  def winner(game_pid) do
    state(game_pid) |> Map.get(:winner)
  end

  def choices(game_pid) do
    state(game_pid) |> Map.get(:choices)
  end

  def players(game_pid) do
    state(game_pid) |> Map.get(:players)
  end

  def state(game_pid) do
    GenServer.call(game_pid, :state)
  end

  def choose(game_pid, role, choice) do
    GenServer.call(game_pid, {:choose, role, choice})
  end

  def set_host(game_pid, player) do
    GenServer.call(game_pid, {:set_host, player})
  end

  def set_guest(game_pid, player) do
    GenServer.call(game_pid, {:set_guest, player})
  end

  # Server (callbacks)
  def init(game_name) do
    initial_state = %GameState{name: game_name}
    {:ok, initial_state}
  end

  def handle_call(:state, _from, game_state) do
    {:reply, game_state, game_state}
  end

  def handle_call({:choose, role, choice}, _from, game_state) do
    new_state = GameState.set_choice(game_state, role, choice)
    {:reply, new_state, new_state}
  end

  def handle_call({:set_host, player}, _from, game_state) do
    new_state = GameState.set_host(game_state, player)
    {:reply, new_state, new_state}
  end

  def handle_call({:set_guest, player}, _from, game_state) do
    new_state = GameState.set_guest(game_state, player)
    {:reply, new_state, new_state}
  end
end
