defmodule Zpid.Display.Object.State do
  @fields [x: 0, y: 0, rotation: 0,
           scale_x: 1, scale_y: 1,
           origin_x: 0, origin_y: 0]
  defmacro __using__(fields \\ []) do
    fields = @fields ++ fields
    quote do
      defstruct unquote(fields)
    end
  end

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
