defmodule Zpid.Web.Router do
  use Zpid.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.Pipeline, module: Zpid.Web.Guardian,
                                 error_handler: Zpid.Web.AuthErrorHandler
    plug Guardian.Plug.VerifySession, module: Zpid.Web.Guardian
    plug Guardian.Plug.LoadResource, module: Zpid.Web.Guardian, allow_blank: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Zpid.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    get "/login", SessionController, :login
    post "/login", SessionController, :create
    post "/logout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Zpid.Web do
  #   pipe_through :api
  # end
end
