defmodule Zpid.Web.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "user:*", Zpid.Web.UserChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    case Zpid.Web.Guardian.resource_from_token(token) do
      {:ok, user, _claims} ->
        socket = socket
                 |> assign(:user, user)
        {:ok, socket}
      _ ->
        {:ok, socket}
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Zpid.Web.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
