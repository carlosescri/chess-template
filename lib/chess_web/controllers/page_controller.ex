defmodule ChessWeb.PageController do
  use ChessWeb, :controller

  alias ChessWeb.Board

  def index(conn, _params) do
    children = [{Board, Board.default()}]
    Supervisor.start_link(children, strategy: :one_for_all)

    render(conn, "index.html")
  end
end
