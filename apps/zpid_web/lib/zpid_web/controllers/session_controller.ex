defmodule Zpid.Web.SessionController do
  use Zpid.Web, :controller

  alias Zpid.Account
  alias Zpid.Account.User

  def login(conn, _params) do
    changeset = Account.change_user(%User{})
    render conn, "login.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    with %{"name" => name,
           "password" => password} <- user_params,
         {:ok, user} <- Account.check_password(name, password) do
      conn
      |> Zpid.Web.Guardian.Plug.sign_in(user)
      |> redirect(to: page_path(conn, :index))
    else
      x ->
        require Logger
        Logger.info(inspect x)
        redirect conn, to: session_path(conn, :login)
    end
  end

  def delete(conn, _) do
    conn
    |> Zpid.Web.Guardian.Plug.sign_out
    |> redirect(to: page_path(conn, :index))
  end
end
