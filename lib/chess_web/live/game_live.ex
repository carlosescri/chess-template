defmodule ChessWeb.GameLive do
  @moduledoc """
  Live View that models a chess board game.
  """

  use ChessWeb, :live_view

  @impl Phoenix.LiveView
  def handle_params(%{"game_id" => game_id}, _uri, socket) do
    IO.inspect(GenServer.call({:global, game_id}, :state))

    {:noreply, socket}
  end

  def get_tile_content(%{assigns: %{board: board}}, col, row) do
    :ok
  end
end
