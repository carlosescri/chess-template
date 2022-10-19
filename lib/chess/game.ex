defmodule Chess.Game do
  @moduledoc false
  # defstruct turn_of: :white, winner: nil

  use Agent

  require Logger

  alias Chess.Dashboard

  def start_link(start_val, opts) do
    Agent.start_link(fn -> start_val end, opts)
  end

  def start(start_val, opts) do
    Agent.start(fn -> start_val end, opts)
  end

  def get_winner(game_agent) do
    get(game_agent, :winner)
  end

  def set_winner(game_agent, winner) do
    set(game_agent, :winner, winner)
  end

  def get_board(game_agent) do
    get(game_agent, :board)
  end

  def set_board(game_agent, board) do
    resp = set(game_agent, :board, board)

    broadcast(game_agent, :new_board)

    resp
  end

  def get_turn_of(game_agent) do
    get(game_agent, :turn_of)
  end

  def get(game_agent, key) do
    Agent.get(game_agent, &Map.get(&1, key))
  end

  def set(game_agent, key, val) do
    Agent.update(game_agent, &Map.put(&1, key, val))
  end

  def next_turn(game_agent) do
    Agent.update(game_agent, fn
      %{turn_of: :white} = state ->
        %{state | turn_of: :black}

      %{turn_of: :black} = state ->
        %{state | turn_of: :white}
    end)
  end

  def subscribe(agent) do
    game_id = get(agent, :game_id)
    Registry.register(Registry.PubSubChess, game_id, "whatever")
    # subscribers = get(agent, :subscribers)
    # set(agent, :subscribers, [self() | subscribers])
  end

  def broadcast(agent, message) do
    game_id = get(agent, :game_id)

    Registry.dispatch(Registry.PubSubChess, game_id, fn entries ->
      for {pid, _} <- entries, do: send(pid, message)
    end)
  end

  def get_game(game_id, user_id) do
    init_data = %{
      game_id: game_id,
      turn_of: :white,
      winner: nil,
      board: Dashboard.new(),
      subscribers: [],
      players: %{white: user_id, black: nil}
    }

    agent =
      case __MODULE__.start(init_data, name: game_name(game_id)) do
        {:ok, pid} ->
          Logger.debug("starting new game #{game_id}")
          pid

        {:error, {:already_started, pid}} ->
          Logger.debug("reading already started game #{game_id}")
          pid
      end

    agent
  end

  def game_name(game_id), do: String.to_atom("Game#{game_id}")
end
