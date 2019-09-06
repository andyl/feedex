defmodule RaggedData.Ctx.News do
  alias RaggedData.Ctx.Account.{User, Folder, FeedLog}
  # alias RaggedData.Ctx.News.{Feed, Post}

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

  # ----- display queries

  # def for_feed(_feed_id) do
  #
  # end

  # def for_feed_log(_feed_log_id) do
  #   # select * from posts p join feeds f on f.id = p.feed_id  where p.feed_id = 24;
  #   from(
  #     p in Post,
  #     join
  #   )
  #   |> Repo.all()
  # end

  def for_user(_user_id) do
  end

  # ----- getters -----

  def get_feed_log(id) do
    Repo.get(FeedLog, id)
  end

  def get_feed(id) do
    Repo.get(Feed, id)
  end

  def get_post(id) do
    Repo.get(Post, id)
  end
end
