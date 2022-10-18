defmodule ChessWeb.SelectorLive do
  use ChessWeb, :live_view

  require IO

  alias Phoenix.LiveView.Socket

  ##########
  # EVENTS #
  ##########

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign_init(socket)}
  end

  @impl Phoenix.LiveView
  def handle_event("send", %{"form" => %{"room" => room, "username" => username}}, socket) do
    assign_and_play(username, room, socket)
  end

  def handle_event("random-room", _params, socket) do
    random = MnemonicSlugs.generate_slug(3)
    {:noreply, assign(socket, :room, random)}
  end

  def handle_event("redirect", _data, socket) do
    {:noreply, push_redirect(socket, to: "/play")}
  end

  ###########
  # PRIVATE #
  ###########

  @spec assign_and_play(binary, binary, Socket.t()) :: {:noreply, Socket.t()}
  defp assign_and_play(username, room, socket) do
    store_obj = %{username: username, room: room}

    {
      :noreply,
      socket
      |> assign(:room, room)
      |> assign(:username, username)
      |> push_event("redirect", store_obj)
    }
  end

  @spec assign_init(Socket.t()) :: Socket.t()
  defp assign_init(socket) do
    socket
    |> assign(:room, "")
    |> assign(:username, "Sam")
    |> push_event("clear", %{clear: ["username", "room"]})
  end
end
