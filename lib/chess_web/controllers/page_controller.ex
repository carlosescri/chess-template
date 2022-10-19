defmodule ChessWeb.PageController do
  use ChessWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new_game(conn, _params) do
    random_id = :rand.uniform(99_999)
    random_id_player = :rand.uniform(99_999)

    %{cookies: cookies} = fetch_cookies(conn)

    conn = redirect(conn, to: Routes.game_path(conn, :index, random_id))

    case cookies do
      %{"user" => _whatever} ->
        halt(conn)

      _ ->
        conn
        |> put_resp_cookie("user", "#{random_id_player}")
        |> halt
    end
  end

  def new_user(conn, %{"uid" => game_id}) do
    %{cookies: cookies} = fetch_cookies(conn)
    random_id_player = :rand.uniform(99_999)

    conn
    |> put_resp_cookie("user", "#{random_id_player}")
    |> redirect(to: Routes.game_path(conn, :index, game_id))
  end

  def get_session_data(conn) do
    %{cookies: cookies} = fetch_cookies(conn)
    cookies
  end
end
