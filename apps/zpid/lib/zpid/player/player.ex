defmodule Zpid.Player do
  use GenServer

  def start_link(id, user_id) do
    GenServer.start_link(__MODULE__, {id, user_id})
  end

  def init({id, user_id}) do
    state = %{id: id, user_id: user_id}
    {:ok, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
