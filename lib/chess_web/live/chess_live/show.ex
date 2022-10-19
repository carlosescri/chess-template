defmodule ChessWeb.ChessLive.Show do
  use Phoenix.LiveView

  alias Chess.Games.GameServer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"game_name"=> game_name}, _, socket) do
    game_name_atom = String.to_atom(game_name)
    game_pid = GameServer.get_pid(game_name_atom)

    {:noreply, assign(socket, game: :sys.get_state(game_pid))}
  end

end
