defmodule Chess.Game do
  @type cell :: {non_neg_integer(), non_neg_integer()}
  @type piece :: [cell()]
  @type board :: [{atom(), atom()}]
  @type state :: %{
          player1: %{piece: atom(), pid: term()},
          player2: %{piece: atom(), pid: term()},
          board: board(),
          mode: atom()
        }

  def new do
    %{
      player1: %{piece: :white, pid: nil},
      player2: %{piece: :black, pid: nil},
      board: get_board(),
      mode: :initial
    }
  end

  def join(_pid, %{player1: %{pid: nil}} = state) do
    {:ok, put_in(state, [:player1, :pid], :ready)}
  end

  def join(pid, %{player1: %{pid: :ready}} = state) do
    {:ok, put_in(state, [:player1, :pid], pid)}
  end

  def join(_pid, %{player2: %{pid: nil}} = state) do
    {:ok, put_in(state, [:player2, :pid], :ready)}
  end

  def join(pid, %{player2: %{pid: :ready}} = state) do
    state =
      state
      |> put_in([:player2, :pid], pid)
      |> Map.put(:mode, :setting)

    {:ok, state}
  end

  def join(_, _) do
    {:error, "Game is full"}
  end

  defp get_board do
    get_cells_board()
    |> Enum.map(fn {row, column} ->
      key = String.to_atom("pos#{row}_#{column}")
      figure = get_type_figure(row, column)

      {key, figure}
    end)
  end

  defp get_cells_board do
    range = 1..8

    Enum.map(range, fn row ->
      Enum.map(range, fn column ->
        {row, column}
      end)
    end)
    |> List.flatten()
  end

  defp get_type_figure(row, column) do
    Enum.map(init_figures(), fn {key, positions} ->
      position = Enum.find(positions, &pos(&1, row, column))
      if position != nil, do: key
    end)
    |> Enum.reject(&is_nil/1)
    |> List.first(:empty)
  end

  defp init_figures do
    [
      {:rook_white, [{8, 1}, {8, 8}]},
      {:rook_black, [{1, 1}, {1, 8}]},
      {:knight_white, [{8, 2}, {8, 7}]},
      {:knight_black, [{1, 2}, {1, 7}]},
      {:bishop_white, [{8, 3}, {8, 6}]},
      {:bishop_black, [{1, 3}, {1, 6}]},
      {:queen_white, [{8, 4}]},
      {:queen_black, [{1, 4}]},
      {:king_white, [{8, 5}]},
      {:king_black, [{1, 5}]},
      {:pawn_white, [{7, 1}, {7, 2}, {7, 3}, {7, 4}, {7, 5}, {7, 6}, {7, 7}, {7, 8}]},
      {:pawn_black, [{2, 1}, {2, 2}, {2, 3}, {2, 4}, {2, 5}, {2, 6}, {2, 7}, {2, 8}]}
    ]
  end

  defp pos({x, y}, row, column) when x == row and y == column, do: {x, y}
  defp pos(_position, _row, _column), do: nil
end
