defmodule ChessWeb.GameLive do
  @moduledoc """
  Live View that models a chess board game.
  """

  use ChessWeb, :live_view

  require Integer

  import ChessWeb.Board.Helpers

  alias Chess.Game
  alias Chess.Game.Figure
  alias Chess.Game.Movements
  alias Chess.Game.State
  alias Chess.Game.Tile
  alias Phoenix.LiveView.Socket

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :selected_tile, nil)}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"game_id" => game_id}, _uri, socket) do
    {:noreply, assign_game_state(socket, game_id)}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "select_tile",
        %{"index" => index},
        %{assigns: %{game_state: game_state}} = socket
      ) do
    tile = Enum.at(game_state.board, String.to_integer(index))

    socket =
      if player_figure?(game_state, tile.figure) do
        assign(socket, :selected_tile, tile.coordinates)
      else
        socket
      end

    {:noreply, socket}
  end

  @spec selected?(Tile.t(), tuple) :: boolean
  def selected?(%{coordinates: coordinates}, coordinates), do: true
  def selected?(_, _), do: false

  @spec square_color(non_neg_integer) :: binary
  def square_color(idx) do
    if Integer.is_even(idx + div(idx, 8)), do: "white", else: "black"
  end

  @spec assign_game_state(Socket.t(), binary) :: Socket.t()
  defp assign_game_state(socket, game_id) do
    assign(socket, :game_state, Game.state(game_id))
  end

  @spec player_figure?(State.t(), Figure.t()) :: boolean
  defp player_figure?(%{turn: color}, %{color: color}), do: true
  defp player_figure?(_, _), do: false
end
