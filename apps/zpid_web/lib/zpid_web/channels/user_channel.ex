defmodule Zpid.Web.UserChannel do
  use Zpid.Web, :channel

  import Zpid.EventDispatcher, only: [listen: 1, dispatch: 1]
  alias Zpid.Account.User
  alias Zpid.Player
  alias Zpid.Player.Input
  alias Zpid.Player.InputDevice
  alias Zpid.Player.Operation
  alias Zpid.Display
  alias Zpid.Display.Object
  alias Zpid.Display.Container
  alias Zpid.Display.Object.ContainerState

  def join("user:" <> user_id, _payload, socket) do
    user_id = String.to_integer(user_id)
    if authorized?(socket, user_id) do
      init(socket, user_id)
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def init(socket, user_id) do
    player_id = Zpid.ID.gen()
    display_id = Zpid.ID.gen()
    container_id = Zpid.ID.gen()
    listen(Display.Event.for(display_id))
    Display.start_link(display_id)
    InputDevice.start_link(player_id)
    state = %{
      container: %ContainerState{
        scale_x: 80,
        scale_y: 80
      }
    }
    dispatch(Object.create(display_id, Container, container_id, state))
    Player.start_link(player_id, user_id, display_id, container_id)
    socket = socket |> assign(:player_id, player_id)
    {:ok, %{id: player_id}, socket}
  end

  def handle_in("movement", %{"x" => x, "y" => y}, socket) do
    dispatch(Input.movement(socket.assigns[:player_id], x, y))
    {:noreply, socket}
  end

  def handle_in("rotation", %{"radian" => radian}, socket) do
    dispatch(Operation.rotation(socket.assigns[:player_id], radian))
    {:noreply, socket}
  end

  def handle_in("start_dash", _, socket) do
    dispatch(Operation.start_dash(socket.assigns[:player_id]))
    {:noreply, socket}
  end

  def handle_in("end_dash", _, socket) do
    dispatch(Operation.end_dash(socket.assigns[:player_id]))
    {:noreply, socket}
  end

  def handle_info(%Display.Event{} = event, socket) do
    case event.action do
      :add ->
        body = %{
          id: event.object_id,
          definition: event.params.definition,
          state: event.params.state,
          parent_id: event.params.parent_id
        }
        push socket, "add_object", body
      :update ->
        body = %{
          id: event.object_id,
          state: event.params.state
        }
        push socket, "update_object", body
      :delete ->
        body = %{id: event.object_id}
        push socket, "delete_object", body
    end
    {:noreply, socket}
  end

  defp authorized?(socket, user_id) do
    case socket.assigns.user do
      %User{id: ^user_id} -> true
      _ -> false
    end
  end
end
