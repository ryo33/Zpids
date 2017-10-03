defmodule Zpids.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Zpids.Repo

  alias Zpids.Account.User

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user(123)
      {:ok, %User{}}

      iex> get_user(456)
      :error

  """
  def get_user(id) do
    case Repo.get(User, id) do
      nil -> :error
      user -> {:ok, user}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    attrs = Map.update!(attrs, "password", fn password ->
      Comeonin.Argon2.hashpwsalt(password)
    end)
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Checks the password
  """
  def check_password(name, password) do
    case Repo.get_by(User, name: name) do
      nil ->
        Comeonin.Argon2.dummy_checkpw()
        :error
      user ->
        if Comeonin.Argon2.checkpw(password, user.password) do
          {:ok, user}
        else
          :error
        end
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
