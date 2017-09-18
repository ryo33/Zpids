defmodule Zpid.Display do
  use GenServer

  import Zpid.EventDispatcher, only: [listen: 1, dispatch: 1]
  alias __MODULE__.Object

  def start_link(id) do
    GenServer.start_link(__MODULE__, id)
  end

  def init(id) do
    listen(Object.Creating.for_display(id))
    {:ok, %{id: id}}
  end

  def handle_info(%Object.Creating{} = event, state) do
    display_id = state.id
    Object.start_link(event.object_id, display_id, event.state)
    dispatch(__MODULE__.Event.add_object(display_id, event.object_id, event.definition, event.state, event.parent_id))
    {:noreply, state}
  end
end
