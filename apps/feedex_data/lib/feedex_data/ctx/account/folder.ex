defmodule FeedexData.Ctx.Account.Folder do
  @moduledoc """
  Folder DataModel.
  """
  use Ecto.Schema
  alias FeedexData.Ctx.Account
  import Ecto.Changeset

  schema "folders" do
    field(:name, :string)
    timestamps(type: :utc_datetime)

    belongs_to :user, Account.User
    has_many :registers, Account.Register
    has_many :read_logs, Account.ReadLog 
    has_many :feeds, through: [:registers, :feeds]
    has_many :posts, through: [:registers, :feeds, :posts]
  end

  def changeset(folder, attrs) do
    required_fields = [:name]
    optional_fields = [:user_id]

    folder
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> validate_length(:name, min: 3, max: 10)
  end

  def new_changeset do
    changeset(%Account.Folder{}, %{})
  end
end
