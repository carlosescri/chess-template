defmodule ChessWeb.HomeLive.Index do

  use ChessWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("create_game", _value, socket) do
    { :noreply, push_redirect(socket, to: "/game")}
  end

end
