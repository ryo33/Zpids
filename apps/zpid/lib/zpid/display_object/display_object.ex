defmodule Zpid.DisplayObject do
  use GenServer

  import Zpid.Dispatcher, only: [listen: 1, dispatch: 1]
  alias Zpid.Display
  alias __MODULE__.Updating
  alias __MODULE__.SpriteState
  alias Zpid.Clock.Tick

  def start_link(object_id, display_id, state) do
    GenServer.start_link(__MODULE__, {object_id, display_id, state})
  end

  def init({object_id, display_id, state}) do
    listen(Updating.for_object(object_id))
    listen(Tick.fps60)
    state = %{
      object_id: object_id,
      display_id: display_id,
      state: state,
      next_state: %{},
      sent: false
    }
    {:ok, state}
  end

  def handle_info(%Tick{fps: 60}, state) do
    %{display_id: display_id,
      next_state: next_state} = state
    state = if map_size(next_state) != 0 do
      diffs = diff(state.state, next_state)
      if map_size(diffs) != 0 do
        dispatch(Display.Event.update_object(display_id, state.object_id, diffs))
      end
      %{state | state: next_state, next_state: %{}}
    else
      state
    end
    state = %{state | sent: false}
    {:noreply, state}
  end

  def handle_info(%Updating{object_id: id, state: object_state}, state) do
    state = if state.sent do
      %{state |
        next_state: Map.merge(state.next_state, object_state)
      }
    else
      next_state = Map.merge(state.state, object_state)
      diffs = diff(state.state, next_state)
      if map_size(diffs) != 0 do
        dispatch(Display.Event.update_object(state.display_id, id, diffs))
      end
      %{state |
        sent: true,
        state: next_state
      }
    end
    {:noreply, state}
  end

  defp diff(state, next_state) do
    Enum.reduce(next_state, %{}, fn {key, next}, diffs ->
      diff = SpriteState.diff(state[key], next)
      if map_size(diff) != 0 do
        Map.put(diffs, key, diff)
      else
        diffs
      end
    end)
  end
end
