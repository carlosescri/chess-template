defmodule Chess.Games do
  @moduledoc """
  The Games context.
  """

  alias Chess.Games.Game
  alias Chess.Movements

  @type cell :: {non_neg_integer(), non_neg_integer()}

  @spec new :: Game.t()
  def new do
    %Game{
      white_player: %{
        pieces: %{
          {0, 0} => :rook,
          {0, 1} => :knight,
          {0, 2} => :bishop,
          {0, 3} => :king,
          {0, 4} => :queen,
          {0, 5} => :bishop,
          {0, 6} => :knight,
          {0, 7} => :rook,
          {1, 0} => :pawn,
          {1, 1} => :pawn,
          {1, 2} => :pawn,
          {1, 3} => :pawn,
          {1, 4} => :pawn,
          {1, 5} => :pawn,
          {1, 6} => :pawn,
          {1, 7} => :pawn
        },
        pid: nil,
        name: nil
      },
      black_player: %{
        pieces: %{
          {7, 0} => :rook,
          {7, 1} => :knight,
          {7, 2} => :bishop,
          {7, 3} => :king,
          {7, 4} => :queen,
          {7, 5} => :bishop,
          {7, 6} => :knight,
          {7, 7} => :rook,
          {6, 0} => :pawn,
          {6, 1} => :pawn,
          {6, 2} => :pawn,
          {6, 3} => :pawn,
          {6, 4} => :pawn,
          {6, 5} => :pawn,
          {6, 6} => :pawn,
          {6, 7} => :pawn
        },
        pid: nil,
        name: nil
      },
      # dashboard: [
      #   {{0, 0}, :white, :rook},
      #   {{0, 1}, :white, :knight},
      #   {{0, 2}, :white, :bishop},
      #   {{0, 3}, :white, :king},
      #   {{0, 4}, :white, :queen},
      #   {{0, 5}, :white, :bishop},
      #   {{0, 6}, :white, :knight},
      #   {{0, 7}, :white, :rook},
      #   {{1, 0}, :white, :pawn},
      #   {{1, 1}, :white, :pawn},
      #   {{1, 2}, :white, :pawn},
      #   {{1, 3}, :white, :pawn},
      #   {{1, 4}, :white, :pawn},
      #   {{1, 5}, :white, :pawn},
      #   {{1, 6}, :white, :pawn},
      #   {{1, 7}, :white, :pawn},
      #   {{2, 0}, nil, nil},
      #   {{2, 1}, nil, nil},
      #   {{2, 2}, nil, nil},
      #   {{2, 3}, nil, nil},
      #   {{2, 4}, nil, nil},
      #   {{2, 5}, nil, nil},
      #   {{2, 6}, nil, nil},
      #   {{2, 7}, nil, nil},
      #   {{2, 0}, nil, nil},
      #   {{3, 1}, nil, nil},
      #   {{3, 2}, nil, nil},
      #   {{3, 3}, nil, nil},
      #   {{3, 4}, nil, nil},
      #   {{3, 5}, nil, nil},
      #   {{3, 6}, nil, nil},
      #   {{3, 7}, nil, nil},
      #   {{3, 0}, nil, nil},
      #   {{4, 1}, nil, nil},
      #   {{4, 2}, nil, nil},
      #   {{4, 3}, nil, nil},
      #   {{4, 4}, nil, nil},
      #   {{4, 5}, nil, nil},
      #   {{4, 6}, nil, nil},
      #   {{4, 7}, nil, nil},
      #   {{5, 0}, nil, nil},
      #   {{5, 1}, nil, nil},
      #   {{5, 2}, nil, nil},
      #   {{5, 3}, nil, nil},
      #   {{5, 4}, nil, nil},
      #   {{5, 5}, nil, nil},
      #   {{5, 6}, nil, nil},
      #   {{5, 7}, nil, nil},
      #   {{6, 0}, :black, :rook},
      #   {{6, 1}, :black, :knight},
      #   {{6, 2}, :black, :bishop},
      #   {{6, 3}, :black, :king},
      #   {{6, 4}, :black, :queen},
      #   {{6, 5}, :black, :bishop},
      #   {{6, 6}, :black, :knight},
      #   {{6, 7}, :black, :rook},
      #   {{7, 0}, :black, :pawn},
      #   {{7, 1}, :black, :pawn},
      #   {{7, 2}, :black, :pawn},
      #   {{7, 3}, :black, :pawn},
      #   {{7, 4}, :black, :pawn},
      #   {{7, 5}, :black, :pawn},
      #   {{7, 6}, :black, :pawn},
      #   {{7, 7}, :black, :pawn}

      # ],
      player_turn: nil,
      game_name: Enum.random(?a..?z),
      start_date: NaiveDateTime.utc_now()
    }
  end

  @spec join_player(Game.t(), map) :: {:error, binary} | Chess.Games.Game.t()
  def join_player(%Game{white_player: %{name: nil}} = game, player) do
    white_player = Map.put(game.white_player, :name, Map.get(player, :name, nil))
    Map.put(game, :white_player, white_player)
  end

  def join_player(%Game{black_player: %{name: nil}} = game, player) do
    black_player = Map.put(game.black_player, :name, Map.get(player, :name, nil))

    game
    |> Map.put(:black_player, black_player)
    |> Map.put(:player_turn, :white)
  end

  def join_player(_, player) do
    {:error,
     "The player #{player.name} cannot join the game because there are already two players"}
  end

  @spec execute_move(Chess.Games.Game.t(), tuple, tuple) ::
          :error | :ok | {:error, binary}
  def execute_move(
        %Game{player_turn: :white} = game,
        {origin_cell_x, origin_cell_y} = origin_cell,
        {final_cell_x, final_cell_y}
      ) do
    case game.black_player.pieces[origin_cell] do
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
