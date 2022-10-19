defmodule Chess.ChessGenServer do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(game_name) do
    GenServer.start_link(__MODULE__, :ok, name: game_name)
  end

  def join(game_name) do
    GenServer.call(game_name, :join)
  end

  def update_board(game_name, updated_board) do
    GenServer.call(game_name, {:update_board, updated_board})
  end

  ## Defining GenServer Callbacks

  @impl true
  def init(:ok) do
    # TODO Remove state when genserver :DOWN
    {:ok, %Chess.Structs.Game{board: init_board()}}
  end

  @impl true
  def handle_call(:join, {current_player_pid, _ref}, state) do
    updated_state = join_player(state, current_player_pid)
    {:reply, {:ok, updated_state.board}, updated_state}
  end

  @impl true
  def handle_call({:update_board, updated_board}, {current_player_pid, _ref}, state) do
    # TODO Manage movement on genserver instead of liveview
    updated_state = Map.put(state, :board, updated_board)
    send_other_player_update(updated_state, current_player_pid)
    {:reply, {:ok, updated_board}, updated_state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _, _}, _state) do
    # TODO Fix reload browser tab does not reload both users pid
    {:noreply, %Chess.Structs.Game{board: init_board()}}
  end

  ## Private genserver functions

  defp init_board() do
    # TODO Implement this programmatically
    [
      [
        {"rook", "black"},
        {"knight", "black"},
        {"bishop", "black"},
        {"queen", "black"},
        {"king", "black"},
        {"bishop", "black"},
        {"knight", "black"},
        {"rook", "black"}
      ],
      [
        {"pawn", "black"},
        {"pawn", "black"},
        {"pawn", "black"},
        {"pawn", "black"},
        {"pawn", "black"},
        {"pawn", "black"},
        {"pawn", "black"},
        {"pawn", "black"}
      ],
      [
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil}
      ],
      [
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil}
      ],
      [
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil}
      ],
      [
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil},
        {nil, nil}
      ],
      [
        {"pawn", "white"},
        {"pawn", "white"},
        {"pawn", "white"},
        {"pawn", "white"},
        {"pawn", "white"},
        {"pawn", "white"},
        {"pawn", "white"},
        {"pawn", "white"}
      ],
      [
        {"rook", "white"},
        {"knight", "white"},
        {"bishop", "white"},
        {"queen", "white"},
        {"king", "white"},
        {"bishop", "white"},
        {"knight", "white"},
        {"rook", "white"}
      ]
    ]
  end

  defp get_other_player_pid(%{player_white: {player}} = state, current_pid)
       when player == current_pid do
    {pid} = state.player_black
    pid
  end

  defp get_other_player_pid(%{player_black: {player}} = state, current_pid)
       when player == current_pid do
    {pid} = state.player_white
    pid
  end

  defp join_player(%{player_white: nil} = state, pid) do
    Map.put(state, :player_white, {pid})
  end

  defp join_player(%{player_black: nil} = state, pid) do
    Map.put(state, :player_black, {pid})
  end

  defp join_player(state, _pid) do
    # TODO Spectators or show a reject message
    state
  end

  defp send_other_player_update(state, current_player_pid) do
    state
    |> get_other_player_pid(current_player_pid)
    |> Kernel.send({:update_board, state.board})
  end
end
