defmodule Zpid.DisplayObject.SpriteState do
  @enforce_keys []
  defstruct x: 0, y: 0, width: 1, height: 1, anchor: %{x: 0, y: 0}, rotation: 0, animation_speed: 0, play: false

  def diff(state, next_state) do
    Map.from_struct(next_state)
    |> Enum.reduce(%{}, fn {key, value}, diff ->
      if Map.get(state, key) != value do
        Map.put(diff, key, value)
      else
        diff
      end
    end)
  end
end
