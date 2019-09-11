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
    reg_qry = from(
      r in Register,
      select: fragment("distinct jsonb_array_elements(r.read_list)::integer")
    )

    from(
      p in Post,
      order_by: [desc: p.id],
      limit: 100,
      left_join: r in subquery(reg_qry), on: p.id == r.post_id,
      select: %{
        id: p.id, 
        exid: p.exid, 
        title: p.title, 
        body: p.body, 
        author: p.author, 
        link: p.link,
        has_read: r.post_id
      }
    )
  end

  def psts_all do
    qall()
    |> Repo.all()
  end

  def posts_all(_user_id \\ 1) do
    qry = 
      """
      with read_list as (
      select distinct jsonb_array_elements(r.read_list)::integer as post_id
      from registers r
      order by post_id
      )
      select p.id, 
      p.exid, 
      p.title, 
      p.body, 
      p.author, 
      p.link, 
      case when r.post_id is NULL then 'f' else 't' end as has_read
      from posts p 
      left join read_list r on p.id = r.post_id 
      order by p.id desc
      limit 100;
      """
    {:ok, data} = RaggedData.Repo.query(qry)
    data.rows
    |> Enum.map(&(%{
      id:       Enum.fetch!(&1, 0),
      exid:     Enum.fetch!(&1, 1),
      title:    Enum.fetch!(&1, 2),
      body:     Enum.fetch!(&1, 3),
      author:   Enum.fetch!(&1, 4),
      link:     Enum.fetch!(&1, 5),
      has_read: Enum.fetch!(&1, 6)
    }))
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
