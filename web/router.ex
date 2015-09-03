defmodule Tracker.Router do
  use Tracker.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", Tracker do
    pipe_through [:browser, :browser_session]
    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
    resources "/users", UserController
  end

  scope "/api/v1", Tracker do
    pipe_through :api
    post "/token", SessionController, :token
  end

  # Other scopes may use custom stacks.
  # scope "/api", Tracker do
  #   pipe_through :api
  # end
end
