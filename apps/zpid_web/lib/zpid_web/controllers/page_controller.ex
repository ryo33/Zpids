defmodule Zpid.Web.PageController do
  use Zpid.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
