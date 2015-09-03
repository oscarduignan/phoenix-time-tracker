defmodule Tracker.User do
  use Tracker.Web, :model
  alias Tracker.Repo

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps
  end

  def authenticate(email, password) do
    case Repo.one(from u in __MODULE__, where: u.email == ^email) do
      %__MODULE__{encrypted_password: encrypted_password} = user ->
        if Comeonin.Pbkdf2.checkpw(password, encrypted_password) do
          { :ok, user }
        else
          { :error, :password_incorrect }
        end
      _ ->
        { :error, :user_not_found }
    end
  end

  def changeset(model, context, params \\ :empty) do
    model
    |> cast(params, required_params(context), optional_params(context))
    |> encrypt_password
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
  end

  defp required_params(:create), do: ~w(email password)
  defp required_params(_), do: ~w()

  defp optional_params(:update), do: ~w(email password)
  defp optional_params(_), do: ~w()

  defp encrypt_password(changeset) do
    case Ecto.Changeset.fetch_change(changeset, :password) do
      { :ok, password } ->
        changeset
        |> change(encrypted_password: Comeonin.Pbkdf2.hashpwsalt(password))
      :error -> changeset
    end
  end
end
