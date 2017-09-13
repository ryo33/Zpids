defmodule Zpid.Clock do
  use GenServer

  @fps [60, 30, 10, 1]
  @frame Enum.map(@fps, &(60 / &1 - 1))

  alias Zpid.Dispatcher
  alias __MODULE__.Tick

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(state) do
    send self(), {:tick, [0, 0, 0, 0]}
    {:ok, state}
  end

  def handle_info({:tick, count}, state) do
    Process.send_after(self(), {:tick, tick(count, @fps, @frame)}, 17)
    {:noreply, state}
  end

  defp tick([count | tail1], [fps | tail2], [frame | tail3]) do
    if count == frame do
      Dispatcher.dispatch(%Tick{fps: fps})
      [0 | tick(tail1, tail2, tail3)]
    else
      [count+1 | tick(tail1, tail2, tail3)]
    end
  end
  defp tick([], [], []), do: []
end
