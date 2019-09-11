defmodule RaggedData.Ctx.Account.Register do
  @moduledoc """
  Register DataModel.
  """
  use Ecto.Schema
  alias RaggedData.Ctx.{Account, News}
  import Ecto.Changeset

  schema "registers" do
    field(:name, :string)
    field(:read_list, {:array, :integer})
    field(:jfields, :map)
    timestamps(type: :utc_datetime)

    belongs_to :folder, Account.Folder
    belongs_to :feed, News.Feed
  end

  def changeset(register, attrs) do
    required_fields = [:name]
    optional_fields = [:folder_id]

    register
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
