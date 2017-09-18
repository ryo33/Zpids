defmodule Zpid.Clock.Tick do
  @behaviour Zpid.Event
  @enforce_keys [:fps]
  defstruct [:fps]

  def to_selector(event) do
    {__MODULE__, event.fps}
  end

  def fps60, do: {__MODULE__, 60}
  def fps30, do: {__MODULE__, 30}
  def fps10, do: {__MODULE__, 10}
  def fps1, do: {__MODULE__, 1}
end
