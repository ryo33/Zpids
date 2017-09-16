defmodule Zpid.Player.InputDevice do
  use GenServer

  import Zpid.Dispatcher, only: [listen: 1, dispatch: 1]
  alias Zpid.Player.Input
  alias Zpid.Player.Operation
  alias Zpid.Clock.Tick

  def start_link(player_id) do
    GenServer.start_link(__MODULE__, player_id)
  end

  def init(player_id) do
    listen(Input.by(player_id))
    listen(Tick.fps60)
    state = %{
      player_id: player_id,
      movement: %{x: 0.0, y: 0.0},
    }
    {:ok, state}
  end

  def handle_info(%Input{action: :movement, value: value}, state) do
    state = Map.put(state, :movement, value)
    {:noreply, state}
  end

  def handle_info(%Tick{fps: 60}, state) do
    operation = if state.movement.x == 0 and state.movement.y == 0 do
      Operation.stop(state.player_id)
    else
      Operation.movement(state.player_id, state.movement)
    end
    dispatch(operation)
    {:noreply, state}
  end
end
