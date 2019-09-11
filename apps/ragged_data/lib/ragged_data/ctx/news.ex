defmodule RaggedData.Ctx.News do
  alias RaggedData.Ctx.News.{Feed, Post}
  alias RaggedData.Repo

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

  # ----- post query -----

  def get_post(id) do
    Repo.get(Post, id)
  end

  # ----- unread_count_for -----

  def unread_count_for(userid) do
    "fld.user_id = #{userid}"
  end

  def unread_count_for(userid, fld_id: fldid) do
    "fld.user_id = #{userid} and fld.fld_id = fldid"
  end

  def unread_count_for(userid, reg_id: regid) do
    "fld.user_id = #{userid}"
  end

  defp unread_count_query(where) do
    """
    with read_list as (
    select distinct jsonb_array_elements(r.read_list)::integer as post_id
    from registers r
    )
    select count(rls.post_id)
    from posts pst
    left join read_list rls on pst.id = rls.post_id 
    join feeds fee on pst.feed_id = fee.id
    join registers reg on reg.feed_id = fee.id
    join folders fld on reg.folder_id = fld.id
    where #{where} and rls.post_id IS NULL
    """
  end

  # ----- unread_ids_for -----

  def unread_ids_for(userid) do
  end

  def unread_ids_for(userid, fld_id: fldid) do
  end

  def unread_ids_for(userid, reg_id: regid) do
  end

  # ----- posts_for -----

  def posts_for(userid) do
    "fld.user_id = #{userid}"
    |> posts_query()
  end

  def posts_for(usrid, fld_id: fldid) do
    "fld.user_id = #{usrid} and fld.id = #{fldid}"
    |> posts_query()
  end

  def posts_for(usrid, reg_id: regid) do
    "fld.user_id = #{usrid} and reg.id = #{regid}"
    "reg.id = #{regid}"
    |> posts_query()
  end

  defp posts_query(where) do
    """
    with read_list as (
    select distinct jsonb_array_elements(r.read_list)::integer as post_id
    from registers r
    order by post_id
    )
    select 
    pst.id, 
    pst.exid, 
    pst.title, 
    pst.body, 
    pst.author, 
    pst.link, 
    pst.updated_at,
    case when rls.post_id is NULL then 'f' else 't' end as has_read
    from posts pst
    left join read_list rls on pst.id = rls.post_id 
    join feeds fee on pst.feed_id = fee.id
    join registers reg on reg.feed_id = fee.id
    join folders fld on reg.folder_id = fld.id
    where #{where}
    order by pst.id desc
    limit 100;
    """
    |> process()
  end

  defp process(query) do
    {:ok, data} = RaggedData.Repo.query(query)
    data.rows
    |> Enum.map(&(%{
      id:       Enum.fetch!(&1, 0),
      exid:     Enum.fetch!(&1, 1),
      title:    Enum.fetch!(&1, 2),
      body:     Enum.fetch!(&1, 3),
      author:   Enum.fetch!(&1, 4),
      link:     Enum.fetch!(&1, 5),
      updated:  Enum.fetch!(&1, 6),
      has_read: Enum.fetch!(&1, 7)
    }))
  end
end
