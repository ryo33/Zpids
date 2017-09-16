defmodule Zpid.DisplayObject.Updating do
  @behaviour Zpid.Event

  @enforce_keys [:display_id, :object_id, :state]
  defstruct [:display_id, :object_id, :state]

  def to_selectors(event) do
    [
      {__MODULE__, event.object_id}
    ]
  end

  def for_object(object_id) do
    {__MODULE__, object_id}
  end

  def event(display_id, object_id, state) do
    %__MODULE__{
      display_id: display_id,
      object_id: object_id,
      state: state}
  end
end
