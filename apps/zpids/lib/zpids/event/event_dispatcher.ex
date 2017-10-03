defmodule Zpids.EventDispatcher do
  use GenServer
  require Logger

  @spec dispatch(Zpids.Event.t) :: :ok
  def dispatch(event) do
    module = event.__struct__
    selector = module.to_selector(event)
    Registry.dispatch(__MODULE__, selector, fn entries ->
      for {pid, :ok} <- entries do
        send pid, event
      end
    end)
    :ok
  end

  @spec listen(selector :: any) :: :ok
  def listen(selector) do
    Registry.register(__MODULE__, selector, :ok)
  end
end
