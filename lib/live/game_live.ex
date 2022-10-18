defmodule ChessWeb.GameLive do

  use ChessWeb, :live_view

  alias Chess.Board

  @impl Phoenix.LiveView
  def mount(_params, _session, socket), do:
    {:ok, socket
      |> assign(:state, Board.initial_board())
      |> assign(:player, :white)}

  @impl Phoenix.LiveView
  def handle_event("select-piece", params, socket) do
    IO.inspect params
    {:noreply, assign(socket, :device, :desktop)}
  end

  def handle_event("send-piece", params, socket) do
    IO.inspect params
    {:noreply, assign(socket, :device, :desktop)}
  end
end
