defmodule ChessWeb.PageController do
  use ChessWeb, :controller

  alias Chess.GameServer

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"id" => id}) do
    case Chess.new_game(id) do
      {:ok, id} ->
        conn
        |> put_flash(:info, "Game #{inspect(id)} created correctly")
        |> redirect(to: Routes.page_path(conn, :index))
        |> halt()

      {:error, reason} ->
        conn
        |> put_flash(:info, reason)
        |> redirect(to: Routes.page_path(conn, :index))
        |> halt()
    end
  end

  def join(conn, %{"id" => id}) do
    
  end
end
