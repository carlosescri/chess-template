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
  alias Chess.Game.StateTransitions
  alias Chess.Game.Tile
  alias Phoenix.LiveView.Socket
  alias Phoenix.PubSub

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :selected_tile, nil)}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"game_id" => game_id}, _uri, socket) do
    if connected?(socket), do: PubSub.subscribe(Chess.PubSub, game_id)

    socket =
      socket
      |> assign(:game_id, game_id)
      |> assign_game_state()

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:game_state_updated, %{assigns: %{game_id: game_id}} = socket) do
    new_state = Game.state(game_id)
    {:noreply, assign(socket, game_state: new_state)}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "select_tile",
        %{"index" => index},
        %{assigns: %{selected_tile: nil, game_state: game_state}} = socket
      ) do
    tile = Enum.at(game_state.board, String.to_integer(index))

    socket =
      if player_figure?(game_state, tile.figure) do
        assign(socket, :selected_tile, tile)
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_event(
        "select_tile",
        %{"index" => index},
        %{assigns: %{game_id: game_id, selected_tile: selected_tile, game_state: game_state}} =
          socket
      ) do
    tile = Enum.at(game_state.board, String.to_integer(index))

    socket =
      cond do
        player_figure?(game_state, tile.figure) ->
          assign(socket, :selected_tile, tile)

        Movements.allowed?(game_state.board, selected_tile, tile) ->
          # Execute movement
          case StateTransitions.transit(:move, selected_tile, tile, game_state) do
            {:ok, new_state} ->
              Game.set_state(game_id, new_state)
              assign(socket, :selected_tile, nil)

            _ ->
              put_flash(socket, :info, "Invalid Movement")
          end

        true ->
          socket
      end

    {:noreply, socket}
  end

  @spec movement_cue(Tile.t() | nil, Tile.t(), State.t()) :: nil | binary
  def movement_cue(nil, _, _), do: nil

  def movement_cue(selected_tile, destination_tile, game_state) do
    if Movements.allowed?(game_state.board, selected_tile, destination_tile) do
      "movement-cue"
    end
  end

  @spec selected?(Tile.t(), Tile.t()) :: boolean
  def selected?(%{coordinates: coordinates}, %{coordinates: coordinates}), do: true
  def selected?(_, _), do: false

  @spec square_color(non_neg_integer) :: binary
  def square_color(idx) do
    if Integer.is_even(idx + div(idx, 8)), do: "white", else: "black"
  end

  @spec assign_game_state(Socket.t()) :: Socket.t()
  defp assign_game_state(%{assigns: %{game_id: game_id}} = socket) do
    assign(socket, :game_state, Game.state(game_id))
  end

  @spec player_figure?(State.t(), Figure.t()) :: boolean
  defp player_figure?(%{game_state: state}, %{color: color}) do
    if color == :white do
      state in [:play_white, :play_white_check]
    else
      state in [:play_black, :play_black_check]
    end
  end

  defp player_figure?(_, _), do: false
end
