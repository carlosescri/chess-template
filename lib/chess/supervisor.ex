defmodule Chess.GamesSupervisor do
  use DynamicSupervisor
  alias Chess.Games
  alias Chess.Games.Game

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_game(user) do
    join_code = Game.create_join_code()

    {:ok, process} = start_child(user, join_code)

    {:ok, join_code}
  end


  def start_child(user, game_id) do
    DynamicSupervisor.start_child(__MODULE__, {Games, {user, game_id}})
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end