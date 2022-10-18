defmodule ChessWeb.GameLive do

  use ChessWeb, :live_view

  alias Chess.Board

  @impl Phoenix.LiveView
  def mount(_params, _session, socket), do:
    {:ok, socket
      |> assign(:state, Board.initial_board())
      |> assign(:player, :white)}
end
