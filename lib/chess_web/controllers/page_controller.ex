defmodule ChessWeb.PageController do
  use ChessWeb, :controller

  alias ChessWeb.Board

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
