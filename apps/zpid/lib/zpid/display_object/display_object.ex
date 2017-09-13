defmodule Zpid.DisplayObject do
  use GenServer

  alias Zpid.Dispatcher
  alias Zpid.Object

  def start_link(id) do
    GenServer.start_link(__MODULE__, id)
  end

  def init(id) do
    Dispatcher.listen(Object.Event.by(id))
    {:ok, id}
  end
end
