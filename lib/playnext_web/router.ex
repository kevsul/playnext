defmodule PlaynextWeb.Router do
  use PlaynextWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlaynextWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/games", GameController, :get_all
    get "/game/:id", GameController, :get
    get "/list/:id", ListController, :get

    get "/import-steam", ImportSteamController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlaynextWeb do
  #   pipe_through :api
  # end
end
