defmodule Zpid.Player do
  use GenServer

  import Zpid.Dispatcher, only: [listen: 1, dispatch: 1]
  alias Zpid.Math.Vector
  alias Zpid.Player.Operation
  alias Zpid.DisplayObject
  alias Zpid.DisplayObject.SpriteState

  @frames Enum.map(0..7, fn i ->
    %{x: i * 32, y: 0, width: 32, height: 42}
  end)
  @sprites %{
    walk: %{
      image_url: "images/temporary/officer_walk_strip.png",
      frames: @frames}}
  @running_speed 4 / 60 # 4m per 60frames
  @walking_speed 1 / 60 # 1m per 60frames

  def start_link(id, user_id, display_id) do
    GenServer.start_link(__MODULE__, {id, user_id, display_id})
  end

  def init({id, user_id, display_id}) do
    listen(Operation.by(id))
    state = %{
      id: id, user_id: user_id, display_id: display_id,
      x: 0.0, y: 0.0, rotation: 0, moving: false, running: false
    }
    dispatch(DisplayObject.Creating.event(display_id, id, @sprites, to_sprite_states(state)))
    {:ok, state}
  end

  def handle_info(%Operation{action: :movement, value: value}, state) do
    speed = if state.running, do: @running_speed, else: @walking_speed
    x = value.x * speed
    y = value.y * speed
    {dx, dy} = Vector.rotate({x, y}, state.rotation + :math.pi/2)
    state = %{state |
      x: state.x + dx,
      y: state.y + dy,
      moving: true}
    dispatch(DisplayObject.Updating.event(state.display_id, state.id, to_sprite_states(state)))
    {:noreply, state}
  end

  def handle_info(%Operation{action: :stop}, state) do
    state = %{state | moving: false}
    dispatch(DisplayObject.Updating.event(state.display_id, state.id, to_sprite_states(state)))
    {:noreply, state}
  end

  def handle_info(%Operation{action: :rotation, value: radian}, state) do
    state = Map.update!(state, :rotation, fn rotation -> rotation + radian end)
    dispatch(DisplayObject.Updating.event(state.display_id, state.id, to_sprite_states(state)))
    {:noreply, state}
  end

  def handle_info(%Operation{action: :start_dash}, state) do
    state = %{state | running: true}
    dispatch(DisplayObject.Updating.event(state.display_id, state.id, to_sprite_states(state)))
    {:noreply, state}
  end

  def handle_info(%Operation{action: :end_dash}, state) do
    state = %{state | running: false}
    dispatch(DisplayObject.Updating.event(state.display_id, state.id, to_sprite_states(state)))
    {:noreply, state}
  end

  defp to_sprite_states(state) do
    animation_speed = if state.running, do: 0.2, else: 0.1
    %{
      walk: %SpriteState{
        x: state.x,
        y: state.y,
        width: 0.4,
        height: 0.6,
        anchor: %{x: 0.5, y: 0.5},
        rotation: state.rotation,
        animation_speed: animation_speed,
        play: state.moving}}
  end
end
