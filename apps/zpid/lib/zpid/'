defmodule Zpid.Display do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, id)
  end

  def init(id) do
    {:ok, %{id: id}}
  end
end
