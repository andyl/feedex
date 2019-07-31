defmodule RaggedData.Ctx.News.Feed do
  @moduledoc """
  Feed DataModel.
  """
  use Ecto.Schema
  alias RaggedData.Ctx.News
  import Ecto.Changeset

  schema "feeds" do
    field(:url, :string)
    field(:name, :string)
    field(:jfields, :map)
    timestamps(type: :utc_datetime)

    has_many :posts, News.Post
  end

  def changeset(user, attrs) do
    required_fields = [:url]
    optional_fields = [:jfields]

    user
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:url)
  end
end
