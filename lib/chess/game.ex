defmodule Chess.Game do
  @moduledoc """
  Game context
  """

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
      white_turn?: true
    }
  end

  @spec build_new_board :: list
  defp build_new_board do
    board = List.duplicate(nil, 64)

    # Set figures starting position
    board
    |> List.replace_at(0, %Tile{figure: %Figure{color: :black, type: :rook}})
    |> List.replace_at(1, %Tile{figure: %Figure{color: :black, type: :knight}})
    |> List.replace_at(2, %Tile{figure: %Figure{color: :black, type: :bishop}})
    |> List.replace_at(3, %Tile{figure: %Figure{color: :black, type: :queen}})
    |> List.replace_at(4, %Tile{figure: %Figure{color: :black, type: :king}})
    |> List.replace_at(5, %Tile{figure: %Figure{color: :black, type: :bishop}})
    |> List.replace_at(6, %Tile{figure: %Figure{color: :black, type: :knight}})
    |> List.replace_at(7, %Tile{figure: %Figure{color: :black, type: :rook}})
    |> List.replace_at(8, %Tile{figure: %Figure{color: :black, type: :pawn}})
    |> List.replace_at(9, %Tile{figure: %Figure{color: :black, type: :pawn}})
    |> List.replace_at(10, %Tile{figure: %Figure{color: :black, type: :pawn}})
    |> List.replace_at(11, %Tile{figure: %Figure{color: :black, type: :pawn}})
    |> List.replace_at(12, %Tile{figure: %Figure{color: :black, type: :pawn}})
    |> List.replace_at(13, %Tile{figure: %Figure{color: :black, type: :pawn}})
    |> List.replace_at(14, %Tile{figure: %Figure{color: :black, type: :pawn}})
    |> List.replace_at(15, %Tile{figure: %Figure{color: :black, type: :pawn}})
    |> List.replace_at(48, %Tile{figure: %Figure{color: :white, type: :pawn}})
    |> List.replace_at(49, %Tile{figure: %Figure{color: :white, type: :pawn}})
    |> List.replace_at(50, %Tile{figure: %Figure{color: :white, type: :pawn}})
    |> List.replace_at(51, %Tile{figure: %Figure{color: :white, type: :pawn}})
    |> List.replace_at(52, %Tile{figure: %Figure{color: :white, type: :pawn}})
    |> List.replace_at(53, %Tile{figure: %Figure{color: :white, type: :pawn}})
    |> List.replace_at(54, %Tile{figure: %Figure{color: :white, type: :pawn}})
    |> List.replace_at(55, %Tile{figure: %Figure{color: :white, type: :pawn}})
    |> List.replace_at(56, %Tile{figure: %Figure{color: :white, type: :rook}})
    |> List.replace_at(57, %Tile{figure: %Figure{color: :white, type: :knight}})
    |> List.replace_at(58, %Tile{figure: %Figure{color: :white, type: :bishop}})
    |> List.replace_at(59, %Tile{figure: %Figure{color: :white, type: :queen}})
    |> List.replace_at(60, %Tile{figure: %Figure{color: :white, type: :king}})
    |> List.replace_at(61, %Tile{figure: %Figure{color: :white, type: :bishop}})
    |> List.replace_at(62, %Tile{figure: %Figure{color: :white, type: :knight}})
    |> List.replace_at(63, %Tile{figure: %Figure{color: :white, type: :rook}})
  end

  @spec generate_game_id :: binary
  def generate_game_id do
    @game_id_length
    |> div(2)
    |> :crypto.strong_rand_bytes()
    |> Base.encode16(case: :lower)
  end
end
