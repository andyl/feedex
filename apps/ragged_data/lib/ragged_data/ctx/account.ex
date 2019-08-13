defmodule RaggedData.Ctx.Account do
  alias RaggedData.Ctx.Account.{User, Folder, FeedLog}
  alias RaggedData.Repo
  alias RaggedData.Util.UtilMap
  import Ecto.Query

  def user_list do
    Repo.all(User)
  end

  def user_get(user_id) do
    Repo.get(User, user_id)
  end

  def user_get_by(params) do
    Repo.get_by(User, params)
  end

  def user_add(opts) do
    %User{}
    |> User.changeset(opts)
    |> Repo.insert()
  end

  def user_signup(opts) do
    %User{}
    |> User.signup_changeset(opts)
    |> Repo.insert()
  end

  def user_changeset(%User{} = user) do
    User.changeset(user, %{})
  end

  def user_change(_user_id) do
  end

  def user_change_pwd(_user_id, _newpwd) do
  end

  def user_delete(_user_id) do
  end

  def user_auth_by_email_and_pwd(email, pwd) do
    user = user_get_by(email: email)

    cond do
      user && Pbkdf2.verify_pass(pwd, user.pwd_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  # ----- tree -----

  def cleantree(user_id) do
    rawtree(user_id) 
    |> UtilMap.retake([:id, :name, :user_id, feed_logs: [:id, :name]])
  end

  def rawtree(user_id) do
    from(
      f in Folder,
      where: f.user_id == ^user_id,
      preload: [:feeds]
    )
    |> Repo.all()
  end

  # ----- 

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
