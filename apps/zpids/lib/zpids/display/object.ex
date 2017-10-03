defmodule Zpids.Display.Object do
  use GenServer

  import Zpids.EventDispatcher, only: [listen: 1, dispatch: 1]
  alias Zpids.Display
  alias __MODULE__.Creating
  alias __MODULE__.Updating
  alias __MODULE__.State
  alias Zpids.Clock.Tick

  @callback definition() :: term
  defmacro __using__(_opts) do
    quote do
      @behaviour Zpids.Display.Object
      import Zpids.Display.Object, only: [defobject: 1]
    end
  end

  @schema_json Path.join(__DIR__, "../../../config/display_object_schema.json")
  @external_resource @schema_json
  @schema @schema_json
  |> File.read!()
  |> Poison.decode!

  def schema, do: @schema

  defmacro defobject(definition) do
    quote do
      json = unquote(definition) |> Poison.encode! |> Poison.decode!
      case ExJsonSchema.Validator.validate(Zpids.Display.Object.schema, json) do
        {:error, x} ->
          raise inspect x
        _ -> :ok
      end
      def definition, do: unquote(definition)
    end
  end

  def create(display_id, module, object_id, state, parent_id \\ nil) do
    %Creating{
      object_id: object_id,
      definition: apply(module, :definition, []),
      state: state,
      display_id: display_id,
      parent_id: parent_id,
    }
  end

  def update(object_id, state) do
    %Updating{
      display_id: nil,
      object_id: object_id,
      state: state}
  end

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
    {:noreply, state}
  end

  def handle_info(%Updating{state: object_state}, state) do
    state = %{state |
      next_state: Map.merge(state.next_state, object_state)
    }
    {:noreply, state}
  end

  defp diff(state, next_state) do
    Enum.reduce(next_state, %{}, fn {key, next}, diffs ->
      diff = State.diff(state[key], next)
      if map_size(diff) != 0 do
        Map.put(diffs, key, diff)
      else
        diffs
      end
    end)
  end
end
