defmodule Chess.Game do
  @moduledoc """
  Game context
  """

  import Chess.Game.Helpers

  alias Chess.Game.State
  alias Chess.Game.StateHandler
  alias Chess.Game.Tile
  alias Chess.Game.Figure

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

  @spec state(binary) :: State.t()
  def state(game_id) do
    GenServer.call({:global, game_id}, :state)
  end

  @spec build_new_game_state(binary) :: State.t()
  defp build_new_game_state(player) do
    %State{
      board: build_new_board(),
      white_player: player,
      turn: :white
    }
  end

  @spec build_new_board :: list
  defp build_new_board do
    board =
      List.duplicate(nil, 64)
      |> Enum.with_index()
      |> Enum.map(fn {_, idx} -> %Tile{coordinates: to_coord(idx)} end)

    # Set figures starting position
    board
    |> List.update_at(0, &%Tile{&1 | figure: %Figure{color: :black, type: :rook}})
    |> List.update_at(1, &%Tile{&1 | figure: %Figure{color: :black, type: :knight}})
    |> List.update_at(2, &%Tile{&1 | figure: %Figure{color: :black, type: :bishop}})
    |> List.update_at(3, &%Tile{&1 | figure: %Figure{color: :black, type: :queen}})
    |> List.update_at(4, &%Tile{&1 | figure: %Figure{color: :black, type: :king}})
    |> List.update_at(5, &%Tile{&1 | figure: %Figure{color: :black, type: :bishop}})
    |> List.update_at(6, &%Tile{&1 | figure: %Figure{color: :black, type: :knight}})
    |> List.update_at(7, &%Tile{&1 | figure: %Figure{color: :black, type: :rook}})
    |> List.update_at(8, &%Tile{&1 | figure: %Figure{color: :black, type: :pawn}})
    |> List.update_at(9, &%Tile{&1 | figure: %Figure{color: :black, type: :pawn}})
    |> List.update_at(10, &%Tile{&1 | figure: %Figure{color: :black, type: :pawn}})
    |> List.update_at(11, &%Tile{&1 | figure: %Figure{color: :black, type: :pawn}})
    |> List.update_at(12, &%Tile{&1 | figure: %Figure{color: :black, type: :pawn}})
    |> List.update_at(13, &%Tile{&1 | figure: %Figure{color: :black, type: :pawn}})
    |> List.update_at(14, &%Tile{&1 | figure: %Figure{color: :black, type: :pawn}})
    |> List.update_at(15, &%Tile{&1 | figure: %Figure{color: :black, type: :pawn}})
    |> List.update_at(48, &%Tile{&1 | figure: %Figure{color: :white, type: :pawn}})
    |> List.update_at(49, &%Tile{&1 | figure: %Figure{color: :white, type: :pawn}})
    |> List.update_at(50, &%Tile{&1 | figure: %Figure{color: :white, type: :pawn}})
    |> List.update_at(51, &%Tile{&1 | figure: %Figure{color: :white, type: :pawn}})
    |> List.update_at(52, &%Tile{&1 | figure: %Figure{color: :white, type: :pawn}})
    |> List.update_at(53, &%Tile{&1 | figure: %Figure{color: :white, type: :pawn}})
    |> List.update_at(54, &%Tile{&1 | figure: %Figure{color: :white, type: :pawn}})
    |> List.update_at(55, &%Tile{&1 | figure: %Figure{color: :white, type: :pawn}})
    |> List.update_at(56, &%Tile{&1 | figure: %Figure{color: :white, type: :rook}})
    |> List.update_at(57, &%Tile{&1 | figure: %Figure{color: :white, type: :knight}})
    |> List.update_at(58, &%Tile{&1 | figure: %Figure{color: :white, type: :bishop}})
    |> List.update_at(59, &%Tile{&1 | figure: %Figure{color: :white, type: :queen}})
    |> List.update_at(60, &%Tile{&1 | figure: %Figure{color: :white, type: :king}})
    |> List.update_at(61, &%Tile{&1 | figure: %Figure{color: :white, type: :bishop}})
    |> List.update_at(62, &%Tile{&1 | figure: %Figure{color: :white, type: :knight}})
    |> List.update_at(63, &%Tile{&1 | figure: %Figure{color: :white, type: :rook}})

     |> List.update_at(27, &%Tile{&1 | figure: %Figure{color: :white, type: :rook}})
  end

  @spec generate_game_id :: binary
  defp generate_game_id do
    @game_id_length
    |> div(2)
    |> :crypto.strong_rand_bytes()
    |> Base.encode16(case: :lower)
  end
end
