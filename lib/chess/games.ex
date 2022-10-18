defmodule Chess.Games do
  use GenServer
  require Logger

  alias Chess.Game.Board

  @registry :game_registry
  @initial_state %{
    players: [],
    turn: 0,
    status: :waiting_for_players,
    board: Board.default_board()
  }

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def log_state(process_name) do
    process_name
    |> via_tuple()
    |> GenServer.call(:log_state)
  end

  def add_player(process_name, player_name) do
    process_name
    |> via_tuple()
    |> GenServer.call({:add_player, player_name})
  end

  def get_current_players(process_name) do
    process_name
    |> via_tuple()
    |> GenServer.call({:get_current_players})
  end

  def get_board(game_id) do
    game_id
    |> via_tuple()
    |> GenServer.call({:get_board})
  end

  def move_figure(game_id, user, from, to) do
    game_id
    |> via_tuple()
    |> GenServer.call({:move_figure, game_id, user, from, to})
  end

  def child_spec(process_name) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [process_name]},
      restart: :transient
    }
  end

  def stop(process_name, stop_reason) do
    process_name
    |> via_tuple()
    |> GenServer.stop(stop_reason)
  end


  @impl true
  def init(name) do
    Logger.info("Starting process #{name}")
    {:ok, @initial_state}
  end

  @impl true
  def handle_call(:log_state, _from, state) do
    {:reply, "State: #{inspect(state)}", state}
  end

  @impl true
  def handle_call({:add_player, new_player}, _from, state) do
    new_state =
      Map.update!(state, :players, fn existing_players ->
        [new_player | existing_players]
      end)

    {:reply, :player_added, new_state}
  end

  def handle_call({:get_current_players}, _from, state) do
    {:reply, Map.get(state, :players), state}
  end

  def handle_call({:get_board}, _from, state) do
    board = Map.get(state, :board)
    {:reply, board, state}
  end

  def handle_call({:move_figure, game_id, user, from, to}, _from, state) do
    board = Map.get(state, :board)

    new_board = Board.move_figure(board, from, to)

    broadcast(game_id, "update_board", new_board)

    {:reply, new_board, Map.put(state, :board, new_board)}
  end

  defp via_tuple(name) do
    {:via, Registry, {@registry, name}}
  end

  def subscribe(game_id) do
    Phoenix.PubSub.subscribe(Chess.PubSub, "game:#{game_id}")
  end

  defp broadcast(game_id, event, data) do
    Phoenix.PubSub.broadcast(Chess.PubSub,"game:#{game_id}", {event, data})
  end
end
