defmodule ChessWeb.GameLive do
  @moduledoc """
  Live view for a game
  """

  use ChessWeb, :live_view

  alias ChessWeb.Board

  @impl Phoenix.LiveView
  def mount(%{"game_id" => game_id}, _session, socket) do
    children = [{Board, Board.default()}]
    Supervisor.start_link(children, strategy: :one_for_all)

    IO.inspect(game_id, label: "this is my game_id")
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
