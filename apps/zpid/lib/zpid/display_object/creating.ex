defmodule Zpid.DisplayObject.Creating do
  @behaviour Zpid.Event

  @enforce_keys [:display_id, :object_id, :sprites, :state]
  defstruct [:display_id, :object_id, :sprites, :state]

  def to_selectors(event) do
    [
      {__MODULE__, event.display_id}
    ]
  end

  def for_display(display_id) do
    {__MODULE__, display_id}
  end

  def event(display_id, object_id, sprites, state) do
    %__MODULE__{
      display_id: display_id,
      object_id: object_id,
      sprites: sprites,
      state: state}
  end
end
