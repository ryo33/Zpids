defmodule Zpids.Display.Object.Creating do
  @behaviour Zpids.Event

  @enforce_keys [:display_id, :object_id, :definition, :state]
  defstruct [:display_id, :object_id, :definition, :state, :parent_id]

  def to_selector(event) do
    {__MODULE__, event.display_id}
  end

  def for_display(display_id) do
    {__MODULE__, display_id}
  end
end
