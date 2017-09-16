defmodule Zpid.Display do
  use GenServer

  import Zpid.Dispatcher, only: [listen: 1, dispatch: 1]
  alias Zpid.DisplayObject

  def start_link(id) do
    GenServer.start_link(__MODULE__, id)
  end

  def init(id) do
    listen(DisplayObject.Creating.for_display(id))
    {:ok, %{id: id}}
  end

  def handle_info(%DisplayObject.Creating{} = event, state) do
    DisplayObject.start_link(event.object_id, state.id, event.state)
    dispatch(__MODULE__.Event.add_object(state. id, event.object_id, event.sprites, event.state))
    {:noreply, state}
  end
end
