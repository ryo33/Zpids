defmodule Zpids.Input.MousePointer do
  use Zpids.Input

  @enforce_keys [:client_id, :x, :y]
  defstruct [:client_id, :x, :y]

  def move(client_id, x, y) do
    %__MODULE__{
      client_id: client_id, x: x, y: y}
  end
end
