defmodule ChessWeb.GameLive do

  use ChessWeb, :live_view

  alias Chess.Board

  @impl Phoenix.LiveView
  def mount(_params, _session, socket), do:
    {:ok, socket
      |> assign(:state, Board.initial_board())
      |> assign(:selected, nil)
      |> assign(:player, :white)}

  @impl Phoenix.LiveView
  def handle_event("select-piece", params, %{assigns: %{selected: nil, state: state}} = socket) do
    coordinate = get_coordinate(params)
    if Map.get(state, coordinate) == nil do
      {:noreply, socket}
    else
      {:noreply, assign(socket, selected: coordinate)}
    end
  end
  
  def handle_event("select-piece", params, %{assigns: %{selected: selected, state: state}} = socket), do:
    {:noreply, socket
    |> assign(:state, Board.move(selected, get_coordinate(params), state))
    |> assign(:selected, nil)}
  
  defp get_coordinate(params), do: {String.to_integer(params["row"]), String.to_integer(params["column"])}
end
