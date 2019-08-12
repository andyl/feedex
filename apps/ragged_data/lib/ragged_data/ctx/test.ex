defmodule RaggedData.Ctx.Test do
  alias RaggedData.Ctx.Account.{User, Folder, FeedLog}
  alias RaggedData.Ctx.News.{Feed, Post}
  alias RaggedData.Repo
  import Ecto.Query

  # ----- query functions -----

  def treemap(user_id) do
    from(
      f in Folder,
      where: f.user_id == ^user_id,
      preload: [:feed_logs]
    )
  end

  def folder_qry(user_id) do
    from(
      f in Folder,
      where: f.user_id == ^user_id,
      preload: [:feeds]
    )
  end

  def fq2(user_id) do
    from(f in folder_qry(user_id), select: %{name: f.name})
  end

  def uu1 do
    userid = first_user_id()

    from(
      u in User,
      where: u.id == ^userid,
      join: f in assoc(u, :folders),
      join: l in assoc(f, :feed_logs),
      preload: [folders: {f, feed_logs: l}]
    )
  end

  def uu2 do
    userid = first_user_id()

    from(
      u in User,
      where: u.id == ^userid,
      join: f in assoc(u, :folders),
      select: %{userid: u.id, folders: %{name: f.name}}
    )
  end

  # ----- query runners -----

  def folder_data(user_id) do
    user_id
    |> folder_qry()
    |> Repo.all()
  end

  def folder_data do
    first_user_id()
    |> folder_data()
  end

  def first_user_id do
    from("users", select: [:id])
    |> Repo.one()
    |> Map.get(:id)
  end
end
