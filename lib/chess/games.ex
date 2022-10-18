defmodule Chess.Games do
  use GenServer
  require Logger

  alias Chess.Game.Board

  @registry :game_registry
  @initial_state %{
    id: nil,
    leader: nil,
    players: MapSet.new(),
    turn: :no_turn,
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

  def get_game(game_id) do
    game_id
    |> via_tuple()
    |> GenServer.call(:get_game)
  end

  def add_player(game_id, player_name) do
    game_id
    |> via_tuple()
    |> GenServer.call({:add_player, player_name, game_id})
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
    |> GenServer.cast({:move_figure, game_id, user, from, to})
  end

  def start_game(game_id) do
    game_id
    |> via_tuple()
    |> GenServer.cast(:start_game)
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
    {:ok, Map.put(@initial_state, :id, name)}
  end

  @impl true
  def handle_call(:log_state, _from, state) do
    {:reply, "State: #{inspect(state)}", state}
  end

  def handle_call(:get_game, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:start_game, state) do
    IO.puts("Starting the game...")
    new_state =
      state
      |> Map.put(:status, :playing)
      |> Map.put(:turn, :white)

    broadcast(Map.get(state, :id), "start_game", new_state)
    {:noreply, }
  end

  @impl true
  def handle_call({:add_player, new_player, game_id}, _from, state) do
    new_state =
      Map.update!(state, :players, fn players -> MapSet.put(players, new_player) end)

    current_players =
      new_state
      |> Map.get(:players)
      |> MapSet.size()

    result = case current_players do
      1 -> :player_added_leader
      2 -> :player_added
      _ -> :viewer_added
    end

    new_state = case result do
      :player_added_leader ->
        Map.put(new_state, :leader, new_player)
      :player_added ->
        if Map.get(new_state, :status) == :waiting_for_players do
          Map.put(new_state, :status, :ready)
        else
          new_state
        end
      _ -> new_state
    end

    broadcast(game_id, "player_connected", new_state)

    {:reply, result, new_state}
  end

  def handle_call({:get_current_players}, _from, state) do
    {:reply, Map.get(state, :players), state}
  end

  def handle_call({:get_board}, _from, state) do
    board = Map.get(state, :board)
    {:reply, board, state}
  end

  def handle_cast({:move_figure, game_id, user, from, to}, state) do
    board = Map.get(state, :board)
    new_board = Board.move_figure(board, from, to)
    broadcast(game_id, "update_board", new_board)
    {:noreply, Map.put(state, :board, new_board)}
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
