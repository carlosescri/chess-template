defmodule ChessWeb.ChessLive.Index do
  @moduledoc """
  Liveview for the chess game
  """

  require Integer

  use ChessWeb, :live_view

  alias ChessWeb.Chess
  alias Phoenix.LiveView.Socket

  @impl Phoenix.LiveView
  def mount(params, session, socket) do
    {:ok, socket |> assign(:game, nil) |> assign(:selected_piece_index, nil)}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"game_name" => name}, url, %{assigns: %{game: nil}} = socket) do
    if connected?(socket) do
      name = String.to_atom(name)

      {:ok, pid} =
        case process = GenServer.whereis(name) do
          nil ->
            GenServer.start_link(Chess, {name, self()}, name: name)

          pid ->
            GenServer.call(pid, {:add_player, self()})

            {:ok, pid}
        end

      game = GenServer.call(pid, :get_game)

      Process.send_after(self(), :update_game, 1000)

      {:noreply, socket |> assign(gen_pid: pid) |> assign(:game, game)}
    else
      {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_info(:update_game, %{assigns: %{gen_pid: pid}} = socket) do
    game = GenServer.call(pid, :get_game)
    Process.send_after(self(), :update_game, 1000)
    {:noreply, assign(socket, game: game)}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "select_or_move",
        %{"position" => index},
        %{assigns: %{selected_piece_index: nil}} = socket
      ) do
    {:noreply, assign(socket, :selected_piece_index, String.to_integer(index))}
  end

  def handle_event(
        "select_or_move",
        %{"position" => index},
        %{assigns: %{selected_piece_index: piece_index, gen_pid: pid}} = socket
      ) do
    game = GenServer.call(pid, {:move, piece_index, String.to_integer(index)})
    {:noreply, socket |> assign(:game, game) |> assign(:selected_piece_index, nil)}
  end

  defp get_figure_class(nil), do: ""

  defp get_figure_class(%{type: type, color: color}),
    do: "figure #{color} #{Atom.to_string(type)}"

  defp is_player?({%{pid: player1_pid}, nil}, pid) do
    player1_pid == pid
  end

  defp is_player?({%{pid: player1_pid}, %{pid: player2_pid}}, pid) do
    player1_pid == pid or player2_pid == pid
  end
end