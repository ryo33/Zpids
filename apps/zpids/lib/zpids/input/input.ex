defmodule Zpids.Input do
  defmacro __using__(_opts) do
    quote do
      @behaviour Zpids.Event

      @impl Zpids.Event
      def to_selector(event) do
        {Zpids.Input, event.client_id}
      end
    end
  end

  def by(client_id) do
    {__MODULE__, client_id}
  end
end
