defmodule ChessWeb.GameLive do
  @moduledoc """
  Live View that models a chess board game.
  """

  use ChessWeb, :live_view

  require Integer

  import ChessWeb.BoardHelpers

  alias Chess.Game
  alias Phoenix.LiveView.Socket

  @impl Phoenix.LiveView
  def handle_params(%{"game_id" => game_id}, _uri, socket) do
    {:noreply, assign_game_state(socket, game_id)}
  end

  @spec square_color(non_neg_integer) :: binary
  def square_color(idx) do
    if Integer.is_even(idx + div(idx, 8)), do: "white", else: "black"
  end

  @spec assign_game_state(Socket.t(), binary) :: Socket.t()
  defp assign_game_state(socket, game_id) do
    assign(socket, :game_state, IO.inspect(Game.state(game_id)))
  end
end
