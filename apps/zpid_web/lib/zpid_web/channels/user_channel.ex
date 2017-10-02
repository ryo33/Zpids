defmodule Zpid.Web.UserChannel do
  use Zpid.Web, :channel

  import Zpid.EventDispatcher, only: [listen: 1, dispatch: 1]
  alias Zpid.Account.User
  alias Zpid.Input.Keyboard
  alias Zpid.Input.MouseButton
  alias Zpid.Input.MousePointer
  alias Zpid.Display

  def join("user:" <> user_id, _payload, socket) do
    user_id = String.to_integer(user_id)
    if authorized?(socket, user_id) do
      init(socket, user_id)
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  defp authorized?(socket, user_id) do
    case socket.assigns.user do
      %User{id: ^user_id} -> true
      _ -> false
    end
  end

  def init(socket, _user_id) do
    client_id = Zpid.ID.gen()
    listen(Display.Event.for(client_id))
    Display.start_link(client_id)
    game_module = Application.get_env(:zpid_web, Zpid.Web)[:zpid_game_module]
    client_module = Application.get_env(:zpid_web, Zpid.Web)[:zpid_game_client_module]
    {width, height} = game_module.display_size()
    {:ok, _} = client_module.start_link(client_id)
    socket = socket |> assign(:client_id, client_id)
    {:ok, %{width: width, height: height}, socket}
  end

  def handle_in("keyboard_press", %{"key" => key}, socket) do
    dispatch(Keyboard.press(socket.assigns.client_id, key))
    {:noreply, socket}
  end

  def handle_in("keyboard_release", %{"key" => key}, socket) do
    dispatch(Keyboard.release(socket.assigns.client_id, key))
    {:noreply, socket}
  end

  def handle_in("mouse_button_press", %{"button" => button}, socket) do
    dispatch(MouseButton.press(socket.assigns.client_id, button))
    {:noreply, socket}
  end

  def handle_in("mouse_button_release", %{"button" => button}, socket) do
    dispatch(MouseButton.release(socket.assigns.client_id, button))
    {:noreply, socket}
  end

  def handle_in("mouse_pointer", %{"x" => x, "y" => y}, socket) do
    dispatch(MousePointer.move(socket.assigns.client_id, x, y))
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
end
