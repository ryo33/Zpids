defmodule Zpid.Web.UserChannel do
  use Zpid.Web, :channel

  alias Zpid.Account.User
  alias Zpid.Dispatcher
  alias Zpid.Player
  alias Zpid.Display
  alias Zpid.DisplayObject

  def join("user:" <> user_id, _payload, socket) do
    user_id = String.to_integer(user_id)
    if authorized?(socket, user_id) do
      player_id = Zpid.ID.gen()
      display_id = Zpid.ID.gen()
      Player.start_link(player_id, user_id)
      Display.start_link(display_id)
      Dispatcher.listen(DisplayObject.Event.for_display(display_id))
      {:ok, %{id: player_id}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(%Display.Event{} = event, socket) do
    event = case event.action do
      :add -> "add_object"
      :delete -> "delete_object"
      :update -> "update_object"
    end
    push socket, event, %{id: event.object.id, object: event.object}
  end

  defp authorized?(socket, user_id) do
    case socket.assigns.user do
      %User{id: ^user_id} -> true
      _ -> false
    end
  end
end
