defmodule RaggedData.Ctx.Account.User do
  @moduledoc """
  User DataModel.
  """
  use Ecto.Schema
  alias RaggedData.Ctx.Account
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:jfields, :map)
    timestamps(type: :utc_datetime)

    has_many :folders, Account.Folder
    has_many :feed_logs, through: [:folders, :feed_logs]
  end

  def changeset(user, attrs) do
    required_fields = [:name]
    optional_fields = [:email, :jfields]

    user
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:uuid)
    |> unique_constraint(:exid)
  end
end
