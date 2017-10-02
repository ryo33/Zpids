defmodule Zpid.Display.Container do
  use GenServer
  use Zpid.Display.Object

  import Zpid.EventDispatcher, only: [listen: 1, dispatch: 1]
  alias Zpid.Display

  defobject %{
    container: %{
      parent: true,
      container: %{}}}

  defmodule Event do
    @behaviour Zpid.Event
    @enforce_keys [:container_id, :action, :params]
    defstruct [:container_id, :action, :params]
    def to_selector(event) do
      {__MODULE__, event.container_id}
    end
    def for(container_id) do
      {__MODULE__, container_id}
    end
  end

  def start_link(container_id, client_id, container_state) do
    GenServer.start_link(__MODULE__, {container_id, client_id, container_state})
  end

  def init({id, client_id, container_state}) do
    listen(Event.for(id))
    dispatch(Display.Object.create(client_id, __MODULE__, id, %{container: container_state}))
    {:ok, %{id: id, container_state: container_state}}
  end

  def handle_info(%Event{action: :update, params: func}, state) do
    state = Map.update!(state, :container_state, func)
    dispatch(Display.Object.update(state.id, %{container: state.container_state}))
    {:noreply, state}
  end

  def update(container_id, func) do
    %Event{
      container_id: container_id,
      action: :update,
      params: func}
  end
end
