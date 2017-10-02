defmodule Zpid do
  @callback display_size() :: {number, number}
  defmacro __using__(_opts) do
    quote do
      @behaviour Zpid
      def display_size, do: {1600, 900}
      defoverridable Zpid
    end
  end
end

defmodule Zpid.Client do
  @callback start_link(client_id :: term) :: {:ok, pid}
  defmacro __using__(_opts) do
    quote do
      @behaviour Zpid.Client
    end
  end
end
