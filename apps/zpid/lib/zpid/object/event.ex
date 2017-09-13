defmodule Zpid.Object.Event do
  @behaviour Zpid.Event

  @enforce_keys [:object_id, :action, :params]
  defstruct [:object_id, :action, :params]

  def to_selectors(event) do
    [
      {__MODULE__, event.object_id}
    ]
  end

  def by(object_id) do
    {__MODULE__, object_id}
  end
end
