defmodule Chess.Games do
  @moduledoc """
  The Games context.
  """

  alias Chess.Games.Game
  alias Chess.Movements

  @type cell :: {non_neg_integer(), non_neg_integer()}

  @spec new(atom) :: Game.t()
  def new(game_name) do
    %Game{
      white_player: %{
        pid: nil,
        name: nil
      },
      black_player: %{
        pid: nil,
        name: nil
      },
      dashboard: %{
        {0, 0} => {:white, :rook},
        {1, 0} => {:white, :knight},
        {2, 0} => {:white, :bishop},
        {3, 0} => {:white, :king},
        {4, 0} => {:white, :queen},
        {5, 0} => {:white, :bishop},
        {6, 0} => {:white, :knight},
        {7, 0} => {:white, :rook},
        {0, 1} => {:white, :pawn},
        {1, 1} => {:white, :pawn},
        {2, 1} => {:white, :pawn},
        {3, 1} => {:white, :pawn},
        {4, 1} => {:white, :pawn},
        {5, 1} => {:white, :pawn},
        {6, 1} => {:white, :pawn},
        {7, 1} => {:white, :pawn},
        {0, 7} => {:black, :rook},
        {1, 7} => {:black, :knight},
        {2, 7} => {:black, :bishop},
        {3, 7} => {:black, :king},
        {4, 7} => {:black, :queen},
        {5, 7} => {:black, :bishop},
        {6, 7} => {:black, :knight},
        {7, 7} => {:black, :rook},
        {0, 6} => {:black, :pawn},
        {1, 6} => {:black, :pawn},
        {2, 6} => {:black, :pawn},
        {3, 6} => {:black, :pawn},
        {4, 6} => {:black, :pawn},
        {5, 6} => {:black, :pawn},
        {6, 6} => {:black, :pawn},
        {7, 6} => {:black, :pawn}
      },
      player_turn: nil,
      game_name: game_name
    }
  end

  @spec join_player(Game.t(), map) :: {:error, binary} | Chess.Games.Game.t()
  def join_player(pid, %Game{white_player: %{name: nil}} = game) do
    white_player = game.white_player |> Map.put(:name, "WHITE") |> Map.put(:pid, pid)
    updated_game = Map.put(game, :white_player, white_player)

    {:ok, updated_game}
  end

  def join_player(pid, %Game{black_player: %{name: nil}} = game) do
    black_player = game.white_player |> Map.put(:name, "BLACK") |> Map.put(:pid, pid)
    updated_game = Map.put(game, :black_player, black_player)

    {:ok, updated_game}
  end

  def join_player(_, _game) do
    {:error,
     "The player cannot join the game because there are already two players"}
  end

  @spec execute_move(Chess.Games.Game.t(), tuple, tuple) ::
          :error | :ok | {:error, binary}
  def execute_move(
        %Game{player_turn: :white} = game,
        {origin_cell_x, origin_cell_y} = origin_cell,
        {final_cell_x, final_cell_y}
      ) do
    case game.white_player.pieces[origin_cell] do
      nil ->
        {:error, "the origin cell is empty"}

      type ->
        diff_x = final_cell_x - origin_cell_x
        diff_y = final_cell_y - origin_cell_y
        Movements.check_movement_by_type(type, diff_x, diff_y)
    end
  end

  def execute_move(
        %Game{player_turn: :black} = game,
        {origin_cell_x, origin_cell_y} = origin_cell,
        {final_cell_x, final_cell_y}
      ) do
    case game.black_player.pieces[origin_cell] do
      nil ->
        {:error, "the origin cell is empty"}

      type ->
        diff_x = origin_cell_x - final_cell_x
        diff_y = origin_cell_y - final_cell_y
        Movements.check_movement_by_type(type, diff_x, diff_y)
    end
  end
end
