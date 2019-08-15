defmodule RaggedData.Ctx.TestQuery do
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
    q = from(fl in FeedLog, select: %{id: fl.id, name: fl.name})

    from(
      f in Folder,
      where: f.user_id == ^user_id,
      preload: [feed_logs: ^q]
    )
  end

  def fq2(user_id) do
    from(f in folder_qry(user_id), select: %{name: f.name})
  end

  # def uu1 do
  #   userid = first_user_id()
  #
  #   from(
  #     u in User,
  #     where: u.id == ^userid,
  #     join: f in assoc(u, :folders),
  #     join: l in assoc(f, :feed_logs),
  #     preload: [folders: {f, feed_logs: l}]
  #   )
  # end
  #
  # def uu2 do
  #   userid = first_user_id()
  #
  #   from(
  #     u in User,
  #     where: u.id == ^userid,
  #     join: f in assoc(u, :folders),
  #     select: %{userid: u.id, folders: %{name: f.name}}
  #   )
  # end

  def fff do
    from(f in Folder, select: %{name: f.name, id: f.id})
  end

  # def uuu(userid \\ first_user_id()) do
  #   q1 =
  #     from(f in Folder,
  #       select: %{name: f.name, id: f.id}
  #     )
  #
  #   q2 =
  #     from(u in User,
  #       where: u.id == ^userid
  #       # merge_select: %{name: u.name, id: u.id}
  #     )
  #
  #   from(u in q2,
  #     preload: ^q1
  #   )
  # end

  def gg1 do
    uid = first_user_id()

    q1 =
      from(f in Folder,
        select: %{name: f.name, id: f.id}
      )

    from(
      u in User,
      where: u.id == ^uid,
      preload: [folders: ^q1]
    )
  end

  def gg2 do
    uid = first_user_id()

    q1 =
      from(f in Folder,
        select: %{name: f.name, id: f.id, user_id: f.user_id}
      )

    from(
      u in "users",
      join: f in "folders",
      on: u.id == f.user_id,
      where: u.id == ^uid,
      select: %{id: u.id, name: u.name, folders: f},
      preload: [folders: ^q1]
    )
  end

  def uf do
    from(
      u in User,
      join: f in assoc(u, :folders)
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
