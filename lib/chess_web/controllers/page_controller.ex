defmodule ChessWeb.PageController do
  use ChessWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end



  def new(conn, %{"data" => %{"username" => user, "join_code" => ""}}) do
    IO.puts("Start a new game.")

    # TODO: Start a new game
    {:ok, join_code} = Chess.GamesSupervisor.start_game()

    redirect(put_session(conn, :username, user), to: "/games/#{join_code}")
  end

  def new(conn, %{"data" => %{"username" => user, "join_code" => join_code} = data}) do
    IO.puts("Joining an already created game.")

    redirect(put_session(conn, :username, user), to: "/games/#{join_code}")
  end

end
