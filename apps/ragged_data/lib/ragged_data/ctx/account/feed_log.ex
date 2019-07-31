defmodule RaggedData.Ctx.Account.FeedLog do
  @moduledoc """
  FeedLog DataModel.
  """
  use Ecto.Schema
  alias RaggedData.Ctx.{Account, News}
  import Ecto.Changeset

  schema "feed_logs" do
    field(:name, :string)
    field(:jfields, :map)
    timestamps(type: :utc_datetime)

    belongs_to :folder, Account.Folder
  end

  def changeset(feed_log, attrs) do
    required_fields = [:name]
    optional_fields = [:folder_id]

    feed_log
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
