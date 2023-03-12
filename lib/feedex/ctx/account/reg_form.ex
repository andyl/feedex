defmodule Feedex.Ctx.Account.RegForm do
  @moduledoc """
  Register DataModel for use in Forms.
  """
  use Ecto.Schema
  # alias Feedex.Ctx.{Account, News}
  import Ecto.Changeset

  schema "registers" do
    field(:name, :string)
    field(:feed_id, :integer)
  end

  def changeset(register, attrs) do
    required_fields = [:name, :feed_id]
    optional_fields = []

    register
    |> IO.inspect(label: "PONG")
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> validate_length(:name, min: 3, max: 15)
    |> unique_constraint(:name, name: :registers_user_id_name_index)
  end
end
