defmodule RaggedData.Ctx.News do
  alias RaggedData.Ctx.News.{Feed, Post}
  alias RaggedData.Ctx.Account.{ReadLog, Register, Folder, User}
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

  # ----- post query -----

  def get_post(id) do
    Repo.get(Post, id)
  end

  # ----- unread_count_for -----

  def unread_count_for(userid) do
    unread_count_qry(userid) |> Repo.one()
  end

  def unread_count_for(userid, fld_id: fldid) do
    from([pst, log, fee, reg, fld] in unread_count_qry(userid),
      where: fld.id == ^fldid
    ) |> Repo.one()
  end

  def unread_count_for(userid, reg_id: regid) do
    from([pst, log, fee, reg, fld] in unread_count_qry(userid),
      where: reg.id == ^regid
    ) |> Repo.one()
  end

  def unread_count_qry(userid) do
    from(pst in Post,
      left_join: log in ReadLog, on: pst.id == log.post_id,
      join:  fee in Feed       , on: pst.feed_id == fee.id,
      join:  reg in Register   , on: reg.feed_id == fee.id,
      join:  fld in Folder     , on: reg.folder_id == fld.id,
      where: fld.user_id == ^userid,
      where: is_nil(log.id), 
      select: count(pst.id)
    )
  end

  # ----- unread_ids_for -----

  def unread_ids_for(_userid) do
  end

  def unread_ids_for(_userid, fld_id: _fldid) do
  end

  def unread_ids_for(_userid, reg_id: _regid) do
  end

  # ----- posts_for -----

  def posts_for(userid) do
    posts_qry(userid) |> Repo.all()
  end

  def posts_for(usrid, fld_id: fldid) do
    from([pst, log, fee, reg, fld] in posts_qry(usrid),
      where: fld.id == ^fldid
    ) |> Repo.all()
  end

  def posts_for(usrid, reg_id: regid) do
    from([pst, log, fee, reg, fld] in posts_qry(usrid),
      where: reg.id == ^regid
    ) |> Repo.all()
  end

  def posts_qry(user_id) do
    from(pst in Post,
      left_join: log in ReadLog, on: pst.id == log.post_id,
      join:  fee in Feed       , on: pst.feed_id == fee.id,
      join:  reg in Register   , on: reg.feed_id == fee.id,
      join:  fld in Folder     , on: reg.folder_id == fld.id,
      where: fld.user_id == ^user_id,
      order_by: [desc: pst.id],
      limit: 100,
      select: %{
        id:         pst.id,
        exid:       pst.exid,
        title:      pst.title,
        body:       pst.body,
        author:     pst.author,
        link:       pst.link,
        updated_at: pst.updated_at,
        read_log:   log.id
      }
    )
  end
end
