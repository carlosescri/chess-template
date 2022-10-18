defmodule ChessWeb.MainLive do
  @moduledoc """
  Live View for the main entry page
  """

  use ChessWeb, :live_view

  alias Chess.Game
  alias ChessWeb.Router.Helpers, as: Router

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :valid_start?, false)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.form let={f} for={:new_game} phx-submit="start_new_game" phx-change="validate" class="new-game-form">
      <div class="new-game-form__hostname">
        <%= label f, :hostname, "Your name" %>
        <%= text_input f, :hostname, placeholder: "Here goes your name, nick, etc..." %>
      </div>
      <div class="new-game-form__start">
        <button
          class="new-game-form__start__btn"
          type="submit"
          disabled={not @valid_start?}
          >
          Start New Game
        </button>
      </div>
    </.form>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"new_game" => %{"hostname" => hostname}}, socket) do
    {:noreply, assign(socket, :valid_start?, String.length(hostname) > 0)}
  end

  def handle_event("start_new_game", %{"new_game" => %{"hostname" => hostname}}, socket) do
    socket =
      case Game.new(hostname) do
        {:ok, game_id} ->
          socket
          |> put_flash(:info, "New game start")
          |> push_redirect(to: Router.game_path(socket, :index, game_id))

        _ ->
          put_flash(socket, :error, "Error: unable to start a new game. Try again later.")
      end

    {:noreply, socket}
  end
end
