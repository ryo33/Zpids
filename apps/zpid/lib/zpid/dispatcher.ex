defmodule Zpid.Dispatcher do
  use GenServer

  @spec dispatch(Zpid.Event.t) :: :ok
  def dispatch(event) do
    module = event.__struct__
    module.to_selectors(event)
    |> Enum.each(fn selector ->
      Registry.dispatch(__MODULE__, selector, fn entries ->
        for {pid, :ok} <- entries do
          send pid, event
        end
      end)
    end)
    :ok
  end

  @spec listen(selector :: any) :: :ok
  def listen(selector) do
    Registry.register(__MODULE__, selector, :ok)
  end
end
