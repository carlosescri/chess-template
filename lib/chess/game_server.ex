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

  def move(game_name, figure, new_position) do
    GenServer.call(game_name, {:move, figure, new_position})
  end

  #SERVER FUNCTIONS

  def init(_) do
    {:ok, Game.new()}
  end

  def handle_call(:join, from, state) do
    {pid, _} = from

    case Game.join(pid, state) do
      {:ok, new_state, player} -> {:reply, {:ok, new_state, player}, new_state}
      {:spectator, new_state} ->
        send_state_to_other_player(new_state, :white)
        send_state_to_other_player(new_state, :black)
        {:reply, {:spectator, new_state}, new_state}
    end
  end

  def handle_call({:move, figure, new_position}, from, state) do
    new_state =
      Game.update_position(state, figure, new_position)
      |> Game.update_turn()
      |> Game.check_finish()

    send_state_to_other_player(new_state, figure.player)
    send_state_to_spectators(new_state)
    {:reply, {:ok, new_state}, new_state}
  end



  # PRIVATE FUNCIONS

  def send_state_to_other_player(state, :white) do
    Process.send(state.pid_player_black, state, [])
  end
  def send_state_to_other_player(state, :black) do
    Process.send(state.pid_player_white, state, [])
  end

  def send_state_to_spectators(state) do
    Enum.each(state.spectators, fn spectator_pid -> Process.send(spectator_pid, state, []) end)
  end
end
