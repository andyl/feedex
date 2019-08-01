defmodule RaggedData.Ctx.Account do

  alias RaggedData.Ctx.Account.{User, Folder, FeedLog}
  alias RaggedData.Repo
  import Ecto.Query, only: [from: 2]

  def user_add(opts) do
    %User{}
    |> User.signup_changeset(opts)
    |> Repo.insert
  end

  def user_update(_user_id, _opts) do
  end

  def user_change_pwd(_user_id, _newpwd) do
  end

  def user_delete(_user_id) do
  end

  def folder_add do
  end

  def folder_update do
  end

  def folder_delete do
  end

  def feed_add do
  end

  def feed_update do
  end

  def feed_delete do
  end

  @doc """
  Mark posts read.

  Options:
    - folder: <folder_id>
    - feed: <feed_id>
    - post: <post_id>
  """
  def mark_read do
  end

  @doc """
  Update the UI state.

  UI State is stored as a JSON field in `User.uistate`.
  """
  def update_ui do
  end

  @doc """
  Count number of elements in the database.
  """
  def count do
    %{
      user: count(User),
      folder: count(Folder),
      feed_log: count(FeedLog)
    }
  end

  def count(type) do
    from(element in type, select: count(element.id))
    |> Repo.one()
  end

end
