defmodule Zpids.Web.PageController do
  use Zpids.Web, :controller

  def index(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        redirect conn, to: session_path(conn, :login)
      user ->
        {:ok, token, _claims} = Zpids.Web.Guardian.encode_and_sign(user)
        render conn, "index.html", token: token, user: user
    end
  end
end
