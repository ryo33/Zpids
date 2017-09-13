defmodule Zpid.DisplayObject.Event do
  @behaviour Zpid.Event

  @enforce_keys [:display_id, :action, :params]
  defstruct [:display_id, :action, :params]

  def to_selectors(event) do
    [
      {__MODULE__, event.display_id}
    ]
  end

  def for_display(display_id) do
    {__MODULE__, display_id}
  end
end
