defmodule Chess.Game do

  alias Chess.Figures

  @spec new :: map()
  def new do
    %{
      turn: :white,
      pid_player_white: nil,
      pid_player_black: nil,
      spectators: [],
      mode: :initial,
      figures: [
        %Figures{position: {1,1}, id: 1, player: :black, type: :rook},
        %Figures{position: {1,2}, id: 2, player: :black, type: :knight},
        %Figures{position: {1,3}, id: 3, player: :black, type: :bishop},
        %Figures{position: {1,4}, id: 4, player: :black, type: :queen},
        %Figures{position: {1,5}, id: 5, player: :black, type: :king},
        %Figures{position: {1,6}, id: 6, player: :black, type: :bishop},
        %Figures{position: {1,7}, id: 7, player: :black, type: :knight},
        %Figures{position: {1,8}, id: 8, player: :black, type: :rook},
        %Figures{position: {2,1}, id: 9, player: :black, type: :pawn},
        %Figures{position: {2,2}, id: 10, player: :black, type: :pawn},
        %Figures{position: {2,3}, id: 11, player: :black, type: :pawn},
        %Figures{position: {2,4}, id: 12, player: :black, type: :pawn},
        %Figures{position: {2,5}, id: 13, player: :black, type: :pawn},
        %Figures{position: {2,6}, id: 14, player: :black, type: :pawn},
        %Figures{position: {2,7}, id: 15, player: :black, type: :pawn},
        %Figures{position: {2,8}, id: 16, player: :black, type: :pawn},
        %Figures{position: {7,1}, id: 17, player: :white, type: :pawn},
        %Figures{position: {7,2}, id: 18, player: :white, type: :pawn},
        %Figures{position: {7,3}, id: 19, player: :white, type: :pawn},
        %Figures{position: {7,4}, id: 20, player: :white, type: :pawn},
        %Figures{position: {7,5}, id: 21, player: :white, type: :pawn},
        %Figures{position: {7,6}, id: 22, player: :white, type: :pawn},
        %Figures{position: {7,7}, id: 23, player: :white, type: :pawn},
        %Figures{position: {7,8}, id: 24, player: :white, type: :pawn},
        %Figures{position: {8,1}, id: 25, player: :white, type: :rook},
        %Figures{position: {8,2}, id: 26, player: :white, type: :knight},
        %Figures{position: {8,3}, id: 27, player: :white, type: :bishop},
        %Figures{position: {8,4}, id: 28, player: :white, type: :queen},
        %Figures{position: {8,5}, id: 29, player: :white, type: :king},
        %Figures{position: {8,6}, id: 30, player: :white, type: :bishop},
        %Figures{position: {8,7}, id: 31, player: :white, type: :knight},
        %Figures{position: {8,8}, id: 32, player: :white, type: :rook},
      ]
    }
  end

  def join(pid, %{pid_player_white: nil} = state) do
    {:ok, Map.put(state, :pid_player_white, pid), :white}
  end

  def join(pid, %{pid_player_black: nil} = state) do
    new_state =
      state
      |> Map.put(:pid_player_black, pid)
      |> Map.put(:mode, :playing)

      Process.send(state.pid_player_white, state, [])

    {:ok, new_state, :black}
  end

  def join(pid, %{spectators: spectators} = state) do
    {:spectator, Map.put(state, :spectators, spectators ++ [pid]) }
  end

  def update_position(state, selected_figure, new_position) do
    figures = Enum.reject(state.figures, fn figure -> selected_figure == figure || figure.position == new_position end)
    new_figure = Map.put(selected_figure, :position, new_position)
    Map.put(state, :figures, figures ++ [new_figure])
  end

  def update_turn(%{turn: :white} = state) do
    Map.put(state, :turn, :black)
  end

  def update_turn(%{turn: :black} = state) do
    Map.put(state, :turn, :white)
  end

  def check_finish(state) do
    white_king = Enum.find(state.figures, fn figure -> figure.player == :white && figure.type == :king end)
    black_king = Enum.find(state.figures, fn figure -> figure.player == :black && figure.type == :king end)

    cond do
      is_nil(white_king) -> Map.put(state, :mode, :black_wins)
      is_nil(black_king) -> Map.put(state, :mode, :white_wins)
      true -> state
    end
  end

  def get_availables_moves(_state, nil) do
    []
  end

  def get_availables_moves(state, %Figures{type: :queen} = figure) do

    get_up_moves(state.figures, figure.position, figure.player, []) ++
    get_down_moves(state.figures, figure.position, figure.player, []) ++
    get_rigth_moves(state.figures, figure.position, figure.player, []) ++
    get_left_moves(state.figures, figure.position, figure.player, []) ++
    get_up_left_moves(state.figures, figure.position, figure.player, []) ++
    get_up_rigth_moves(state.figures, figure.position, figure.player, []) ++
    get_down_left_moves(state.figures, figure.position, figure.player, []) ++
    get_down_rigth_moves(state.figures, figure.position, figure.player, [])
    |> Enum.reject(fn {row, column} -> (row < 1  or row > 8) || (column < 1 or column > 8) end)
  end

  def get_availables_moves(_state, _figure) do
    []
  end

  def get_up_moves(_figures, {0, _column}, _player, acc) do
    acc
  end

  def get_up_moves(figures, {row, column}, player, acc) do
    cond do
      Enum.any?(figures, fn figure -> figure.position == {(row - 1), column} && figure.player == player end) -> acc
      Enum.any?(figures, fn figure -> figure.position == {(row - 1), column} end) -> acc ++ [{(row - 1), column}]
      true -> get_up_moves(figures, {(row - 1), column}, player, acc ++ [{(row - 1), column}])
    end
  end

  def get_down_moves(_figures, {9, _column}, _player, acc) do
    acc
  end

  def get_down_moves(figures, {row, column}, player, acc) do
    cond do
      Enum.any?(figures, fn figure -> figure.position == {(row + 1), column} && figure.player == player end) -> acc
      Enum.any?(figures, fn figure -> figure.position == {(row + 1), column} end) -> acc ++ [{(row + 1), column}]
      true -> get_down_moves(figures, {(row + 1), column}, player, acc ++ [{(row + 1), column}])
    end
  end

  def get_rigth_moves(_figures, {_row, 9}, _player, acc) do
    acc
  end

  def get_rigth_moves(figures, {row, column}, player, acc) do
    cond do
      Enum.any?(figures, fn figure -> figure.position == {row, (column + 1)} && figure.player == player end) -> acc
      Enum.any?(figures, fn figure -> figure.position == {row, (column + 1)} end) -> acc ++ [{row, (column + 1)}]
      true -> get_rigth_moves(figures, {row, (column + 1)}, player, acc ++ [{row, (column + 1)}])
    end
  end

  def get_left_moves(_figures, {_row, 0}, _player, acc) do
    acc
  end

  def get_left_moves(figures, {row, column}, player, acc) do
    cond do
      Enum.any?(figures, fn figure -> figure.position == {row, (column - 1)} && figure.player == player end) -> acc
      Enum.any?(figures, fn figure -> figure.position == {row, (column - 1)} end) -> acc ++ [{row, (column - 1)}]
      true -> get_left_moves(figures, {row, (column - 1)}, player, acc ++ [{row, (column - 1)}])
    end
  end

  def get_up_rigth_moves(_figures, {_row, 9}, _player, acc) do
    acc
  end

  def get_up_rigth_moves(_figures, {0, _column}, _player, acc) do
    acc
  end

  def get_up_rigth_moves(figures, {row, column}, player, acc) do
    cond do
      Enum.any?(figures, fn figure -> figure.position == {(row - 1), (column + 1)} && figure.player == player end) -> acc
      Enum.any?(figures, fn figure -> figure.position == {(row - 1), (column + 1)} end) -> acc ++ [{(row - 1), (column + 1)}]
      true -> get_up_rigth_moves(figures, {(row - 1), (column + 1)}, player, acc ++ [{(row - 1), (column + 1)}])
    end
  end

  def get_up_left_moves(_figures, {_row, 0}, _player, acc) do
    acc
  end

  def get_up_left_moves(_figures, {0, _column}, _player, acc) do
    acc
  end

  def get_up_left_moves(figures, {row, column}, player, acc) do
    cond do
      Enum.any?(figures, fn figure -> figure.position == {(row - 1), (column - 1)} && figure.player == player end) -> acc
      Enum.any?(figures, fn figure -> figure.position == {(row - 1), (column - 1)} end) -> acc ++ [{(row - 1), (column - 1)}]
      true -> get_up_left_moves(figures, {(row - 1), (column - 1)}, player, acc ++ [{(row - 1), (column - 1)}])
    end
  end

  def get_down_left_moves(_figures, {_row, 0}, _player, acc) do
    acc
  end

  def get_down_left_moves(_figures, {9, _column}, _player, acc) do
    acc
  end

  def get_down_left_moves(figures, {row, column}, player, acc) do
    cond do
      Enum.any?(figures, fn figure -> figure.position == {(row + 1), (column - 1)} && figure.player == player end) -> acc
      Enum.any?(figures, fn figure -> figure.position == {(row + 1), (column - 1)} end) -> acc ++ [{(row + 1), (column - 1)}]
      true -> get_down_left_moves(figures, {(row + 1), (column - 1)}, player, acc ++ [{(row + 1), (column - 1)}])
    end
  end

  def get_down_rigth_moves(_figures, {_row, 9}, _player, acc) do
    acc
  end

  def get_down_rigth_moves(_figures, {9, _column}, _player, acc) do
    acc
  end

  def get_down_rigth_moves(figures, {row, column}, player, acc) do
    cond do
      Enum.any?(figures, fn figure -> figure.position == {(row + 1), (column + 1)} && figure.player == player end) -> acc
      Enum.any?(figures, fn figure -> figure.position == {(row + 1), (column + 1)} end) -> acc ++ [{(row + 1), (column + 1)}]
      true -> get_down_rigth_moves(figures, {(row + 1), (column + 1)}, player, acc ++ [{(row + 1), (column + 1)}])
    end
  end
end
