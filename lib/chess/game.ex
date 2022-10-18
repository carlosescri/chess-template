defmodule Chess.Game do
  @moduledoc """
  Game context
  """

  alias Chess.Game.State
  alias Chess.Game.StateHandler

  @game_id_length 30

  @doc """
  Starts a new game with creator_name as player1
  """
  @spec new(binary) :: {:ok, binary} | {:error, :unable_to_start}
  def new(creator_name) do
    game_id = generate_game_id()

    case GenServer.start(StateHandler, build_new_game_state(creator_name),
           name: {:global, game_id}
         ) do
      {:ok, _} ->
        {:ok, game_id}

      _ ->
        {:error, :unable_to_start}
    end
  end

  @doc """
  Joins an existing name by game_name for player_name
  """
  @spec join(binary, binary) :: atom
  def join(_game_name, _player_name) do
    :ok
  end

  @spec build_new_game_state(binary) :: State.t()
  defp build_new_game_state(player) do
    %State{
      board: build_new_board(),
      white_player: player,
      white_turn?: true
    }
  end

  @spec build_new_board :: map
  defp build_new_board do
    IO.puts("BUILD NEW BOARD")
    row = %{a: nil, b: nil, c: nil, d: nil, e: nil, f: nil, g: nil}
    Enum.reduce(1..8, %{}, fn col_idx, board -> Map.put(board, col_idx, row) end)
  end

  @spec generate_game_id :: binary
  def generate_game_id do
    @game_id_length
    |> div(2)
    |> :crypto.strong_rand_bytes()
    |> Base.encode16(case: :lower)
  end
end
