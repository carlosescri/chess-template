defmodule Chess.GameServer do
  use GenServer

  require Logger

  alias Chess.Game

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

  def connect(game_id, player_name) do
    game_id
    |> via_tuple()
    |> GenServer.call({:connect, player_name})
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

    broadcast(game.id, "start_game", new_game)
    {:noreply, new_game}
  end

  def handle_call({:connect, player}, _from, game) do
    new_game =
      case {MapSet.size(game.players), MapSet.member?(game.players, player)} do
        {0, _} -> %Game{game | players: MapSet.put(game.players, player)}
        {1, false} -> %Game{game | players: MapSet.put(game.players, player), status: :ready}
        {_, true} -> game
        {_, false} -> %Game{game | viewers: MapSet.put(game.viewers, player)}
      end

    broadcast(game.id, "player_connected", new_game)
    {:reply, new_game, new_game}
  end

  def handle_call(:get_current_players, _from, game) do
    {:reply, game.players, game}
  end

  def handle_call(:get_board, _from, game) do
    {:reply, game.board, game}
  end

  def handle_cast({:move_figure, user, from, to}, game) do
    case Game.move_figure(game, user, from, to) do
      {:ok, new_game} ->
        broadcast(game.id, "update_board", new_game)
        {:noreply, new_game}

      {:error, reason} ->
        Logger.error(reason)
        {:noreply, game}
    end
  end

  defp via_tuple(game_id) do
    {:via, Registry, {@registry, game_id}}
  end

  def subscribe(game_id) do
    Phoenix.PubSub.subscribe(Chess.PubSub, "game:#{game_id}")
  end

  defp broadcast(game_id, event, data) do
    Phoenix.PubSub.broadcast(Chess.PubSub, "game:#{game_id}", {event, data})
  end
end
