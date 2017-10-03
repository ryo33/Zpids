defmodule Zpids.Input.Keyboard do
  use Zpids.Input

  @enforce_keys [:client_id, :action, :key]
  defstruct [:client_id, :action, :key]

  def press(client_id, key) do
    %__MODULE__{
      client_id: client_id,
      action: :press,
      key: key}
  end

  def release(client_id, key) do
    %__MODULE__{
      client_id: client_id,
      action: :release,
      key: key}
  end
end
