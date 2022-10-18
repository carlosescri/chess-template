defmodule Chess.Games do
  use GenServer
  require Logger

  alias Chess.Games.Game

  @registry :game_registry

  def start_link({user, game_id} = init_args) do
    GenServer.start_link(__MODULE__, init_args, name: via_tuple(game_id))
  end

  def log_state(game_id) do
    game_id
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

  def get_current_players(game_id) do
    game_id
    |> via_tuple()
    |> GenServer.call(:get_current_players)
  end

  def get_board(game_id) do
    game_id
    |> via_tuple()
    |> GenServer.call(:get_board)
  end

  def move_figure(game_id, user, from, to) do
    game_id
    |> via_tuple()
    |> GenServer.cast({:move_figure, user, from, to})
  end

  def start_game(game_id) do
    game_id
    |> via_tuple()
    |> GenServer.cast(:start_game)
  end

  def child_spec({user, game_id}) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [{user, game_id}]},
      restart: :transient
    }
  end

  def stop(game_id, stop_reason) do
    game_id
    |> via_tuple()
    |> GenServer.stop(stop_reason)
  end


  @impl true
  def init({user, game_id}) do
    Logger.info("Starting GenServer for game: #{game_id}")

    {:ok, Game.new(game_id, user)}
  end

  @impl true
  def handle_call(:log_state, _from, game) do
    {:reply, "State: #{inspect(game)}", game}
  end

  def handle_call(:get_game, _from, game) do
    {:reply, game, game}
  end

  def handle_cast(:start_game, game) do
    new_game = Game.start(game)

    broadcast(game.id, "start_game", new_game.status)
    {:noreply, new_game}
  end


  # TODO: Handle adding new player
  @impl true
  def handle_call({:add_player, new_player, game_id}, _from, game) do
    new_state =
      Map.update!(game, :players, fn players -> MapSet.put(players, new_player) end)

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

  def handle_call(:get_current_players, _from, game) do
    {:reply, game.players, game}
  end

  def handle_call(:get_board, _from, game) do
    {:reply, game.board, game}
  end

  def handle_cast({:move_figure, user, from, to}, game) do
    %{board: new_board} = new_game = Game.move_figure(game, user, from, to)
    broadcast(game.id, "update_board", new_board)
    {:noreply, new_game}
  end

  defp via_tuple(game_id) do
    {:via, Registry, {@registry, game_id}}
  end

  def subscribe(game_id) do
    Phoenix.PubSub.subscribe(Chess.PubSub, "game:#{game_id}")
  end

  defp broadcast(game_id, event, data) do
    Phoenix.PubSub.broadcast(Chess.PubSub,"game:#{game_id}", {event, data})
  end
end
