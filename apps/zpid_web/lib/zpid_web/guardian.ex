defmodule Zpid.Web.Guardian do
  use Guardian, otp_app: :zpid_web

  alias Zpid.Account
  alias Zpid.Account.User

  def from_token("user:" <> user_id) do
    case Account.get_user(user_id) do
      {:ok, user} -> {:ok, user}
      :error -> {:error, "no user"}
    end
  end

  def subject_for_token(%User{} = user, _claims) do
    {:ok, "user:#{user.id}"}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    case claims["sub"] do
      "user:" <> user_id ->
        case Account.get_user(user_id) do
        {:ok, user} -> {:ok, user}
        :error -> {:error, "no user"}
        end
      _ ->
        {:error, "no user"}
    end
  end
end
