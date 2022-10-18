defmodule ChessWeb.Router do
  use ChessWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ChessWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChessWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/game", ChessWeb do
    pipe_through :browser

    live("/:game_name", GameLive, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChessWeb do
  #   pipe_through :api
  # end
end
