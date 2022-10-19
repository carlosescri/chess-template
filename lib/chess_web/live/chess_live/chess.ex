defmodule ChessWeb.Chess do
  use GenServer

  alias Chess.Game
  alias Chess.Player
  alias Chess.Piece
  alias Phoenix.PubSub

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

    send_game_update(game)

    {:reply, game, state}
  end

  def handle_call(:get_game, _from, %{game: game} = state) do
    {:reply, game, state}
  end

  def handle_call({:move, from_index, to_index}, _from, %{game: game} = state) do
    case move_piece(game.board, from_index, to_index) do
      {:ok, board} ->
        game = game |> Map.put(:board, board) |> change_turn()
        state = Map.put(state, :game, game)

        send_game_update(game)

        {:reply, game, state}

      {:error, message} ->
        {:reply, game, state}
    end
  end

  defp send_game_update(game) do
    PubSub.broadcast(:chess_pubsub, "game_update", game)
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
      color = if index > 15, do: "white", else: "black"

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

  # Todo blocked by other piece
  defp can_be_moved?(%{type: :pawn, color: color} = piece, board, from, to) do
    cond do
      from + 8 == to or from - 8 == to ->
        dest_piece = Enum.at(board, to)
        check_dest_piece(piece, dest_piece)

      from + 9 == to or from + 7 == to or from - 9 == to or from - 7 == to ->
        dest_piece = Enum.at(board, to)
        IO.inspect(piece)
        can_eat?(piece, dest_piece) |> IO.inspect()

      (from in 9..16 and (to == from + 8 or to == from + 16)) or
          (from in 48..56 and (to == from - 8 or to == from - 16)) ->
        true

      true ->
        false
    end
  end

  defp can_be_moved?(%{type: :rook, color: color} = piece, board, from, to) do
    if is_integer(from - to / 7) do
      false
    else
      true
    end
  end

  defp can_be_moved?(piece, board, from, to) do
    true
  end

  defp check_dest_piece(_, nil), do: true
  defp check_dest_piece(%{color: color}, %{color: dest_color}) when color != dest_color, do: true
  defp check_dest_piece(_), do: false

  defp change_turn(%{turn: :white} = game), do: Map.put(game, :turn, :black)
  defp change_turn(%{turn: :black} = game), do: Map.put(game, :turn, :white)

  defp can_eat?(%{color: "white"}, %{color: "black"}), do: true
  defp can_eat?(%{color: "black"}, %{color: "white"}), do: true
  defp can_eat?(_, _), do: false
end
