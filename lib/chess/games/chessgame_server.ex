defmodule Chess.Games.ChessgameServer do

use GenServer

 # Callbacks

 @impl true
 def init(chess_game) do
   {:ok, chess_game}
 end

 @impl true
 def handle_call(:pop, _from, [head | tail]) do
   {:reply, head, tail}
 end

 @impl true
 def handle_cast({:push, element}, state) do
   {:noreply, [element | state]}
 end

  def start_link(game_name) do
    GenServer.start_link(__MODULE__, nil, name: game_name)
  end
end
