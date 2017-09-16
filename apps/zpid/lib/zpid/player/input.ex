defmodule Zpid.Player.Input do
  @behaviour Zpid.Event

  @enforce_keys [:player_id, :action, :value]
  defstruct [:player_id, :action, :value]

  def to_selectors(event) do
    [
      {__MODULE__, event.player_id}
    ]
  end

  def by(player_id) do
    {__MODULE__, player_id}
  end

  def movement(player_id, x, y) do
    %__MODULE__{
      player_id: player_id,
      action: :movement,
      value: %{x: x, y: y}}
  end
end
