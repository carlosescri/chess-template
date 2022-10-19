defmodule Chess.Game.StateTransitions do
  @moduledoc """
  State machine that ensures coherent states after actions

  states:

  play_white
  play_white_check
  play_black
  play_black_check
  black_wins
  white_wins
  """

  alias Chess.Game.Tile
  alias Chess.Game.State

  @spec transit(:move, Tile.t(), Tile.t(), State.t()) ::
          {:ok, State.t()} | {:error, atom, State.t()}
  def transit(:move, %{figure: figure} = from_tile, to_tile, state) when not is_nil(figure) do
  end

  def transit(:move, _, _, state), do: {:error, :invalid_movement, state}
end
