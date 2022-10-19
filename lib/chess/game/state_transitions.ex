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

  import Chess.Game.Helpers

  alias Chess.Game.Movements
  alias Chess.Game.State
  alias Chess.Game.Tile

  @spec transit(:move, Tile.t(), Tile.t(), State.t()) ::
          {:ok, State.t()} | {:error, atom, State.t()}
  def transit(:move, %{figure: figure} = from_tile, to_tile, %{board: board} = state)
      when not is_nil(figure) do
    if Movements.allowed?(board, from_tile, to_tile) do
      from_figure = from_tile.figure

      new_board =
        board
        |> List.update_at(to_index(from_tile.coordinates), &%Tile{&1 | figure: nil})
        |> List.update_at(to_index(to_tile.coordinates), &%Tile{&1 | figure: from_figure})

      # TODO: Check adversary king "check"
      # TODO: Check adversary king "check mate"
      transit_state = if white_turn?(state), do: :play_white, else: :play_black

      new_state =
        state
        |> Map.put(:board, new_board)
        |> Map.put(:game_state, transit_state)

      {:ok, new_state}
    else
      {:error, :invalid_movement, state}
    end
  end

  def transit(:move, _, _, state), do: {:error, :invalid_movement, state}
end
