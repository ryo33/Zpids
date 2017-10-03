defmodule Zpids.Web.Router do
  use Zpids.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.Pipeline, module: Zpids.Web.Guardian,
                                 error_handler: Zpids.Web.AuthErrorHandler
    plug Guardian.Plug.VerifySession, module: Zpids.Web.Guardian
    plug Guardian.Plug.LoadResource, module: Zpids.Web.Guardian, allow_blank: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Zpids.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    get "/login", SessionController, :login
    post "/login", SessionController, :create
    post "/logout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Zpids.Web do
  #   pipe_through :api
  # end
end
