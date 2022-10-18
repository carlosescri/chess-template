defmodule Chess.Games.Game do
  alias Chess.Game.Board

  defstruct [:id, :leader, :players, :turn, :status, :board]

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
      turn: :no_turn,
      status: :waiting_for_players,
      board: Board.default_board()
    }
  end

  def start(game) do
    %__MODULE__{game | status: :playing, turn: :white}
  end

  def move_figure(%__MODULE__{board: current_board, turn: turn, leader: leader, status: status} = game, user, from, to)
      when user == leader and turn == :white
      when user != leader and turn == :black
      when turn == :no_turn # TODO(Remove): Allow moving around in invalid states
      when status in [:waiting_for_users, :ready, :playing]
    do

    %__MODULE__{game | board: Board.move_figure(current_board, from, to)}
  end

  def move_figure(game,user,_,_) do
    {:error, "invalid user moved"}
  end

end