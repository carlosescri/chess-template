defmodule ChessWeb.GameAgent do
  use Agent

  def start_link(initial_state) do
    Agent.start_link(fn -> initial_state end, name: Map.get(initial_state, :game_id))
  end

  def state(name), do: Agent.get(name, & &1)

  def square_info(game_id, position) do
    game_id |> state() |> get_in([:board, position])
  end
end
