defmodule Zpids do
  @callback display_size() :: {number, number}
  defmacro __using__(_opts) do
    quote do
      @behaviour Zpids
      def display_size, do: {1600, 900}
      defoverridable Zpids
    end
  end
end

defmodule Zpids.Client do
  @callback start_link(client_id :: term) :: {:ok, pid}
  defmacro __using__(_opts) do
    quote do
      @behaviour Zpids.Client
    end
  end
end
