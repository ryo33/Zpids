defmodule Zpid.Input do
  defmacro __using__(_opts) do
    quote do
      @behaviour Zpid.Event

      @impl Zpid.Event
      def to_selector(event) do
        {Zpid.Input, event.client_id}
      end
    end
  end

  def by(client_id) do
    {__MODULE__, client_id}
  end
end
