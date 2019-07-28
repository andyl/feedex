defmodule RaggedData.Ctx.Account.User do
  @moduledoc """
  User DataModel.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:jfields, :map)
    timestamps(type: :utc_datetime)
  end

  def changeset(tracker, attrs) do
    required_fields = [:name]
    optional_fields = [:email, :jfields]

    tracker
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:uuid)
    |> unique_constraint(:exid)
  end
end
