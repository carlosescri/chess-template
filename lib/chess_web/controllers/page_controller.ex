defmodule ChessWeb.PageController do
  use ChessWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end


  @impl Phoenix.LiveView
  def handle_params(%{"game_name" => game_name}, _uri, socket) do
    IO.inspect(game_name)
    {
      :noreply,
      socket
      |> assign("game_name", game_name)
    }
  end
end
