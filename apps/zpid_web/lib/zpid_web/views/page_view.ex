defmodule Zpid.Web.PageView do
  use Zpid.Web, :view

  @display_width Application.get_env(:zpid, Zpid)[:display_width]
  @display_height Application.get_env(:zpid, Zpid)[:display_height]
  def width, do: @display_width
  def height, do: @display_height
end
