defmodule ChessWeb.GameLive do
  use Phoenix.LiveView

  alias Chess.Game

  require Integer

  def mount(_params, _session, socket) do
    game_positions = Game.start()
    board =
    for i <- 1..8 do
      for j <- 1..8 do
        cell_color =
          if Integer.is_odd(i) and Integer.is_even(j) do
            "white"
          else Integer.is_even(i) and Integer.is_odd(j)
            "black"
          end

        %{:item => Map.get(game_positions, {i,j}, false), :cell_color => cell_color}
      end
    end

    {:ok, assign(socket, game_positions: board)}
  end
end
