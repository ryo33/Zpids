defmodule Zpid.Player.Operation do
  @behaviour Zpid.Event

  @enforce_keys [:player_id, :action, :value]
  defstruct [:player_id, :action, :value]

  def to_selector(event) do
    {__MODULE__, event.player_id}
  end

  def by(player_id) do
    {__MODULE__, player_id}
  end

  def stop(player_id) do
    %__MODULE__{
      player_id: player_id,
      action: :stop,
      value: nil}
  end

  def movement(player_id, movement) do
    %__MODULE__{
      player_id: player_id,
      action: :movement,
      value: movement}
  end

  def rotation(player_id, radian) do
    %__MODULE__{
      player_id: player_id,
      action: :rotation,
      value: radian
    }
  end

  def start_dash(player_id) do
    %__MODULE__{
      player_id: player_id,
      action: :start_dash,
      value: nil
    }
  end

  def end_dash(player_id) do
    %__MODULE__{
      player_id: player_id,
      action: :end_dash,
      value: nil
    }
  end
end
