defmodule RaggedData.Ctx.News do
  alias RaggedData.Ctx.Account.{Folder, Register}
  alias RaggedData.Ctx.News.{Feed, Post}
  alias RaggedData.Repo

  import Ecto.Query

  @doc """
  Scan a URL, find the true url, return the RSS data.

  Called by `Account#folder_add()`.
  """
  def scan(_url) do
  end

  @doc """
  Update a RSS URL.

  Called by `Account#folder_update()`.
  """
  def update do
  end

  def for_user(_user_id) do
  end

  # ----- feeds -----
  def feed_get(id) do
    Repo.get(Feed, id)
  end

  # ----- posts -----

  def get_post(id) do
    Repo.get(Post, id)
  end

  def qall do
    from(
      p in Post,
      order_by: [desc: p.id],
      limit: 100,
      select: %{
        id: p.id, 
        exid: p.exid, 
        title: p.title, 
        body: p.body, 
        author: p.author, 
        link: p.link
      }
    )
  end

  def posts_all do
    qall()
    |> Repo.all()
  end

  def posts_for_folder(fld_id) do
    from(
      p in qall(),
      join: f in Feed, on: f.id == p.feed_id,
      join: r in Register, on: f.id == r.feed_id,
      where: r.folder_id == ^fld_id
    ) |> Repo.all()
  end

  def posts_for_register(reg_id) do
    from(
      p in qall(),
      join: f in Feed, on: f.id == p.feed_id,
      join: r in Register, on: f.id == r.feed_id,
      where: r.id == ^reg_id
    ) |> Repo.all()
  end
end
