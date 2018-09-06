defmodule Np.Accounts.User do
  use Ecto.Schema
  alias __MODULE__
  import Ecto.Changeset


  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string


    timestamps()
  end

  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> validate_length(:username, min: 3, max: 35)
    |> unique_constraint(:username)
 end

  def registration_changeset(%User{}=user, attrs \\ %{}) do
    user
    |> changeset(attrs)
    |> cast(attrs, :password)
    |> validate_required(:password, min: 6)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: pass}}=changeset) do
        change(changeset, Comeonin.Argon2.add_hash(pass))
  end

  defp put_hash_pass(changeset), do: changeset
end
