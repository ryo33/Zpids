defmodule Zpid.Web.PageController do
  use Zpid.Web, :controller

  def index(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        redirect conn, to: session_path(conn, :login)
      user ->
        {:ok, token, claims} = Zpid.Web.Guardian.encode_and_sign(user)
        render conn, "index.html", token: token, user: user
    end
  end
end
