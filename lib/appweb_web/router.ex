defmodule AppWebWeb.Router do
  use AppWebWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppWebWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/render-components", PageController, :components
    get "/manual-update-components", PageController, :manual_update
    get "/callbacks", PageController, :callbacks
    get "/multiapp/:app", PageController, :multiapp
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWebWeb do
  #   pipe_through :api
  # end
end
