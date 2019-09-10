defmodule RaggedData.Ctx.News.Post do
  @moduledoc """
  Post DataModel.
  """
  use Ecto.Schema
  alias RaggedData.Ctx.News
  import Ecto.Changeset

  schema "posts" do
    field(:exid,    :string)
    field(:title,   :string)
    field(:body,    :string)
    field(:author,  :string)
    field(:link,    :string)
    field(:updated, :utc_datetime)
    field(:jfields, :map)
    timestamps(type: :utc_datetime)

    belongs_to :feed, News.Feed 
  end

  def changeset(user, attrs) do
    required_fields = [:exid, :body]
    optional_fields = [:feed_id, :jfields]

    user
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:uuid)
  end
end
