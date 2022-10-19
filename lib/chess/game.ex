defmodule Chess.Game do
  @type cell :: {non_neg_integer(), non_neg_integer()}
  @type piece :: [cell()]
  @type state :: %{
          player1: %{pieces: [], pid: term()},
          player2: %{pieces: [], pid: term()},
          mode: atom()
        }

  # INITIAL MODE

  @spec new :: state()
  def new do
    %{
      player1: %{
        pid: nil,
        turn: true
      },
      player2: %{pid: nil, turn: false},
      mode: :initial,
      history: []
    }
  end

  @spec join(pid(), state()) :: {:ok, state()} | {:error, binary()}
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
      |> Map.put(:mode, :playing)

    {:ok, state}
  end

  def join(_, _) do
    {:error, "Game is full"}
  end

  # PLAYING MODE
  # @spec move({cell, term()}, state) :: {:error, binary} | {:ok, state}
  # def move({_piece, pid}, %{mode: player} = state) when player in [:player1, :player2] do

  # end

  # def move(_, _), do: {:error, "You cannot move there"}

  # OTHER NECESARY FUNCTIONS

  @spec player(term, state) :: :player1 | :player2 | :error
  def player(pid, state) do
    cond do
      pid == state.player1.pid -> :player1
      pid == state.player2.pid -> :player2
      true -> :error
    end
  end

  def other_player(:player1), do: :player2
  def other_player(:player2), do: :player1

  # PRIVATE FUNCTIONS
end
