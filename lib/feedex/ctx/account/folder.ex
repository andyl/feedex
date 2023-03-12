defmodule Feedex.Ctx.Account.Folder do
  @moduledoc """
  Folder DataModel.
  """
  alias Feedex.Ctx.Account
  alias Feedex.Repo

  import Ecto.Query
  import Ecto.Changeset
  use Ecto.Schema

  schema "folders" do
    field(:name, :string)
    field(:stopwords, :string)
    timestamps(type: :utc_datetime)

    belongs_to :user, Account.User
    has_many :registers, Account.Register
    has_many :read_logs, Account.ReadLog
    has_many :feeds, through: [:registers, :feeds]
    has_many :posts, through: [:registers, :feeds, :posts]
  end

  def changeset(folder, attrs) do
    required_fields = [:name]
    optional_fields = [:user_id, :stopwords]

    folder
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> validate_length(:name, min: 3, max: 10)
    |> unique_constraint(:name, name: :folder_user_name_index)
  end

  def find_folder(user_id, name) do
    Repo.get_by(Account.Folder, user_id: user_id, name: name)
  end

  def create_folder(user_id, name) do
    params = %{user_id: user_id, name: name}
    {:ok, folder} = %Account.Folder{} |> Account.Folder.changeset(params) |> Repo.insert()
    folder
  end

  def update_folder(folder, opts) do
    folder
    |> changeset(opts)
    |> Repo.update()
  end

  def delete_folder(folder) do
    folder
    |> Repo.delete()
  end

  def by_id(folder_id) do
    Repo.get_by(Account.Folder, id: folder_id)
  end

  def new_changeset do
    changeset(%Account.Folder{}, %{})
  end

  def register_count(folder_id) when is_integer(folder_id) do
    from(r in Account.Register, select: count(r.id), where: r.folder_id == ^folder_id)
    |> Repo.one([])
  end

  def register_count(%Account.Folder{} = folder) do
    register_count(folder.id)
  end
end
