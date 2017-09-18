defmodule Zpid.Display.Container do
  use Zpid.Display.Object

  defobject %{
    container: %{
      parent: true,
      container: %{}}}
end
