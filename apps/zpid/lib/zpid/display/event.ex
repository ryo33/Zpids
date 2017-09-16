defmodule Zpid.Display.Event do
  @behaviour Zpid.Event

  @enforce_keys [:display_id, :object_id, :action, :params]
  defstruct [:display_id, :object_id, :action, :params]

  def to_selectors(event) do
    [
      {__MODULE__, event.display_id}
    ]
  end

  def for(display_id) do
    {__MODULE__, display_id}
  end

  def add_object(display_id, object_id, sprites, state) do
    %__MODULE__{
      display_id: display_id,
      object_id: object_id,
      action: :add,
      params: %{
        sprites: sprites,
        state: state}}
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
