defmodule Zpids.Input.MouseButton do
  use Zpids.Input

  @enforce_keys [:client_id, :action, :button]
  defstruct [:client_id, :action, :button]

  def press(client_id, button) do
    %__MODULE__{
      client_id: client_id,
      action: :press,
      button: button}
  end

  def release(client_id, button) do
    %__MODULE__{
      client_id: client_id,
      action: :release,
      button: button}
  end
end
