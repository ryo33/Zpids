defmodule Zpids.Display.Event do
  @behaviour Zpids.Event

  @enforce_keys [:display_id, :object_id, :action, :params]
  defstruct [:display_id, :object_id, :action, :params]

  def to_selector(event) do
    {__MODULE__, event.display_id}
  end

  def for(display_id) do
    {__MODULE__, display_id}
  end

  def add_object(display_id, object_id, definition, state, parent_id) do
    %__MODULE__{
      display_id: display_id,
      object_id: object_id,
      action: :add,
      params: %{
        definition: definition,
        state: state,
        parent_id: parent_id}}
  end

  def delete_object(display_id, object_id) do
    %__MODULE__{
      display_id: display_id,
      object_id: object_id,
      action: :delete,
      params: nil}
  end

  def update_object(display_id, object_id, state) do
    %__MODULE__{
      display_id: display_id,
      object_id: object_id,
      action: :update,
      params: %{state: state}}
  end
end
