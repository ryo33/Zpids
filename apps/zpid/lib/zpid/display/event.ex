defmodule Zpid.Display.Event do
  @behaviour Zpid.Event

  @enforce_keys [:display_id, :action, :params]
  defstruct [:display_id, :action, :params]

  def to_selectors(event) do
    [
      {__MODULE__, event.display_id}
    ]
  end
end
