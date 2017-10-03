defmodule Zpids.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Zpids.Account.User


  schema "users" do
    field :name, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :password])
    |> validate_required([:name, :password])
    |> unique_constraint(:name)
  end
end
