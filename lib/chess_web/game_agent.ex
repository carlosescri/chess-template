defmodule ChessWeb.GameAgent do
  use Agent

  def start_link(initial_state) do
    Map.get(initial_state, :game) |> IO.inspect()
    Agent.start_link(fn -> initial_state end, name: Map.get(initial_state, :game))
  end

  def state(name), do: Agent.get(name, & &1)

  def get_people_joined(name), do: name |> state() |> Map.get(:people_joined)

  def add_white_player(name, token) do
    Agent.update(name, &put_in(&1, [:players], %{players_from_state(&1) | white: token}))
    increment_people_joined(name)
  end

  def maybe_add_black_player(name, token) do
    players = Agent.get(name, &Map.get(&1, :players, %{}))

    if Map.get(players, :white) != token do
      Agent.update(name, &put_in(&1, [:players], %{players_from_state(&1) | black: token}))
      increment_people_joined(name)
      :black_joined
    else
      nil
    end
  end

  def increment_people_joined(name) do
    Agent.update(name, &put_in(&1, [:people_joined], people_joined_from_state(&1) + 1))
  end

  def join_to_game(name, %{"_csrf_token" => token}) do
    case get_people_joined(name) do
      0 ->
        add_white_player(name, token)
        :white_joined

      1 ->
        maybe_add_black_player(name, token)

      _ ->
        :spectator_joined
    end
  end

  defp people_joined_from_state(state), do: Map.get(state, :people_joined, 0)
  defp players_from_state(state), do: Map.get(state, :players, %{})

  def game_exists?(game) do
    state(game) == nil
  end

  def square_info(game, position) do
    game |> state() |> get_in([:board, position])
  end
end
