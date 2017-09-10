defmodule Zpid.Web.UserChannel do
  use Zpid.Web, :channel

  alias Zpid.Account.User

  def join("user:" <> user_id, _payload, socket) do
    user_id = String.to_integer(user_id)
    if authorized?(socket, user_id) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(socket, user_id) do
    case socket.assigns.user do
      %User{id: ^user_id} -> true
      _ -> false
    end
  end
end
