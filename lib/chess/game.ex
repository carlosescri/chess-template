defmodule Chess.Game do
  alias Chess.Game.Board
  alias Chess.Game.Figure

  defstruct [:id, :leader, :players, :viewers, :turn, :status, :board]

  def create_join_code() do
    <<:rand.uniform(1_048_576)::40>>
    |> Base.encode32()
    |> binary_part(4, 4)
  end

  def new(game_id, user) do
    %__MODULE__{
      id: game_id,
      leader: user,
      players: MapSet.new([user]),
      viewers: MapSet.new([]),
      turn: :no_turn,
      status: :waiting_for_players,
      board: Board.default_board()
    }
  end

  def start(game) do
    %__MODULE__{game | status: :playing, turn: :white}
  end

  def select_figure(game, position) do
    IO.puts("Select figure: (#{elem(position, 0)},#{elem(position, 1)})")
    figure = Map.get(game.board, position, nil)

    IO.puts("Figure at position:")
    IO.inspect(figure)

    case figure do
      nil -> :error
      _ -> :ok
    end
  end

  def move_figure(
        %__MODULE__{board: current_board, turn: turn, leader: leader, status: status} = game,
        user,
        from,
        to
      )
      when user == leader and turn == :white
      when user != leader and turn == :black do
    with %Figure{color: color} <- Map.get(current_board, from),
         true <- color == turn,
         {:ok, board} <- Board.move_figure(current_board, from, to) do
      {
        :ok,
        %__MODULE__{
          game
          | board: board,
            turn: next_turn(turn)
        }
      }
  else
    {:error, reason} -> {:error, reason}
    _ -> {:error, "Trying to move other player figures!"}
   end
  end

  def move_figure(game, user, _, _) do
    {:error, "invalid user moved"}
  end

  def get_player_mode(game, user) do
    cond do
      game.leader == user -> :master
      MapSet.member?(game.players, user) -> :player
      true -> :viewer
    end
  end

  def get_player_figures(game, user) do
    cond do
      game.leader == user -> :white
      game.leader != user and MapSet.member?(game.players, user) -> :black
      MapSet.member?(game.viewers, user) -> :no_player
    end
  end

  defp next_turn(:white), do: :black
  defp next_turn(:black), do: :white
end
