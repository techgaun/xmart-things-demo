defmodule XmartThingsDemo.Router do
  use XmartThingsDemo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", XmartThingsDemo do
    pipe_through :api
    put "/locks/:cmd", PageController, :lock
  end

  scope "/", XmartThingsDemo do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/locks", PageController, :lock
    get "/auth/callback", AuthController, :callback
    get "/auth/:provider", AuthController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", XmartThingsDemo do
  #   pipe_through :api
  # end
end
