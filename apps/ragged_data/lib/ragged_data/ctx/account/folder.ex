defmodule RaggedData.Ctx.Account.Folder do
  @moduledoc """
  Folder DataModel.
  """
  use Ecto.Schema
  alias RaggedData.Ctx.Account
  import Ecto.Changeset

  schema "folders" do
    field(:name, :string)
    field(:jfields, :map)
    timestamps(type: :utc_datetime)

    belongs_to :user, Account.User
    has_many :feed_logs, Account.FeedLog
  end

  def changeset(folder, attrs) do
    required_fields = [:name]
    optional_fields = [:user_id]

    folder
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
