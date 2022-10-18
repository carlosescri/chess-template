defmodule ChessWeb.Chess do
  use GenServer

  alias Chess.Game
  alias Chess.Player
  alias Chess.Piece

  @initial_board_state %{
    rook: [0, 7, 56, 63],
    knight: [1, 6, 57, 62],
    bishop: [2, 5, 58, 61],
    king: [4, 60],
    queen: [3, 59],
    pawn: [8, 9, 10, 11, 12, 13, 14, 15, 48, 49, 50, 51, 52, 53, 54, 55]
  }

  @impl GenServer
  def init({name, pid}) do
    game = start_game(name, pid)
    {:ok, %{game: game}}
  end

  def handle_call({:add_player, liveview_pid}, _from, %{game: game} = state) do
    game = add_player(game, liveview_pid)
    state = Map.put(state, :game, game)

    {:reply, game, state}
  end

  def handle_call(:get_game, _from, %{game: game} = state) do
    {:reply, game, state}
  end

  def handle_call({:move, from_index, to_index}, _from, %{game: game} = state) do
    {:ok, board} = move_piece(game.board, from_index, to_index)
    game = Map.put(game, :board, board)
    state = Map.put(state, :game, game)

    {:reply, game, state}
  end

  defp start_game(name, pid) do
    board = initialize_board()
    players = initialize_players(pid)

    %Game{
      name: name,
      turn: :white,
      players: players,
      board: board
    }
  end

  defp initialize_board() do
    Enum.map(0..63, fn index ->
      color = if index <= 15, do: "white", else: "black"

      cond do
        @initial_board_state |> Map.get(:rook) |> Enum.member?(index) ->
          %Piece{type: :rook, color: color}

        @initial_board_state |> Map.get(:knight) |> Enum.member?(index) ->
          %Piece{type: :knight, color: color}

        @initial_board_state |> Map.get(:bishop) |> Enum.member?(index) ->
          %Piece{type: :bishop, color: color}

        @initial_board_state |> Map.get(:king) |> Enum.member?(index) ->
          %Piece{type: :king, color: color}

        @initial_board_state |> Map.get(:queen) |> Enum.member?(index) ->
          %Piece{type: :queen, color: color}

        @initial_board_state |> Map.get(:pawn) |> Enum.member?(index) ->
          %Piece{type: :pawn, color: color}

        true ->
          nil
      end
    end)
  end

  defp initialize_players(pid) do
    {%Player{pid: pid}, nil}
  end

  defp add_player(%{players: {player, nil}} = game, pid) do
    Map.put(game, :players, {player, %Player{pid: pid}})
  end

  defp add_player(%{players: {_, _}} = game, _pid) do
    game
  end

  defp move_piece(board, from, to) do
    {piece, _} = List.pop_at(board, from)

    if can_be_moved?(piece, board, from, to) do
      board = board |> List.replace_at(to, piece) |> List.replace_at(from, nil)
      {:ok, board}
    else
      {:error, "The piece can not be moved there."}
    end
  end

  defp can_be_moved?(piece, board, from, to) do
    true
  end
end
