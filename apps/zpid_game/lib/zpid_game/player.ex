defmodule Zpid.Game.Player do
  use GenServer
  use Zpid.Display.Object

  import Zpid.EventDispatcher, only: [listen: 1, dispatch: 1]
  alias Zpid.Clock.Tick
  alias Zpid.Math.Vector
  alias Zpid.Input
  alias Zpid.Input.Keyboard
  alias Zpid.Input.MousePointer
  alias Zpid.Display
  alias Zpid.Display.Object.AnimatedSpriteState

  @width 32
  @height 42
  @frames Enum.map(0..3, fn i ->
    %{x: i * 32, y: 0, width: @width, height: @height}
  end)
  defobject %{
    walk: %{
      animated_sprite: %{
        image_url: "images/player.png",
        frames: @frames}}}
  @dash_speed 4 / 60 # 4m per 60frames
  @walking_speed 1 / 60 # 1m per 60frames


  def start_link(id, client_id, parent_id) do
    GenServer.start_link(__MODULE__, {id, client_id, parent_id})
  end

  def init({id, client_id, parent_id}) do
    listen(Input.by(client_id))
    listen(Tick.fps60)
    state = %{
      id: id, client_id: client_id, parent_id: parent_id,
      x: 0.0, y: 0.0, rotation: 0, moving: false,
      sensivility: 0.005,
      input: %{
        up: false,
        down: false,
        left: false,
        right: false,
        dash: false
      },
    }
    dispatch(Display.Object.create(client_id, __MODULE__, id, to_object_state(state), parent_id))
    {:ok, state}
  end

  @keys ~w(w a s d shift)
  @key_actions %{
    "w" => :up,
    "s" => :down,
    "a" => :left,
    "d" => :right,
    "shift" => :dash}
  def handle_info(%Keyboard{key: key, action: action}, state) when key in @keys do
    key_state = case action do
      :press -> true
      :release -> false
    end
    action = @key_actions[key]
    state = put_in(state, [:input, action], key_state)
    {:noreply, state}
  end

  def handle_info(%MousePointer{x: x}, state) do
    state = Map.update!(state, :rotation, fn rotation -> rotation + x * state.sensivility end)
    dispatch(Display.Object.update(state.id, to_object_state(state)))
    {:noreply, state}
  end

  def handle_info(%Tick{fps: 60}, state) do
    %{up: up, down: down, left: left, right: right} = state.input
    move_x = case {left, right} do
      {true, false} -> -1
      {false, true} -> 1
      _ -> 0
    end
    move_y = case {up, down} do
      {true, false} -> -1
      {false, true} -> 1
      _ -> 0
    end
    state = if move_x != 0 or move_y != 0 do
      speed = if state.input.dash, do: @dash_speed, else: @walking_speed
      x = move_x * speed
      y = move_y * speed
      {dx, dy} = Vector.rotate({x, y}, state.rotation)
      %{state |
        x: state.x + dx,
        y: state.y + dy,
        moving: true}
    else
      %{state | moving: false}
    end
    dispatch(Display.Object.update(state.id, to_object_state(state)))
    {:noreply, state}
  end

  defp to_object_state(state) do
    animation_speed = if state.input.dash, do: 0.2, else: 0.1
    %{
      walk: %AnimatedSpriteState{
        x: state.x,
        y: state.y,
        scale_x: 0.4 / @width,
        scale_y: 0.6 / @height,
        anchor_x: 0.5,
        anchor_y: 0.5,
        rotation: state.rotation,
        animation_speed: animation_speed,
        play: state.moving}}
  end
end
