defmodule Zpids.Web.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, reason}, _opts) do
    body = Poison.encode!(%{type: to_string(type), reason: reason})
    send_resp(conn, 401, body)
  end
end
