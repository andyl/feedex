defmodule RaggedData.Ctx.News.Feed do
  @moduledoc """
  Feed DataModel.
  """
  use Ecto.Schema
  alias RaggedData.Ctx.{News, Account}
  import Ecto.Changeset

  schema "feeds" do
    field(:name, :string)
    field(:url, :string)
    field(:jfields, :map)
    timestamps(type: :utc_datetime)

    has_many :posts, News.Post
  end

  def changeset(feed, attrs) do
    required_fields = [:url]
    optional_fields = [:jfields]

    feed
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> validate_length(:name, min: 4)
    |> unique_constraint(:url)
  end

  def new_changeset do
    changeset(%News.Feed{}, %{})
  end
end
