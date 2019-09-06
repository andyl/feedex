defmodule RaggedData.Ctx.News do
  alias RaggedData.Ctx.Account.{User, Folder, Register}
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
    IO.inspect Repo.get(Feed, id)
  end

  # ----- posts -----

  def get_post(id) do
    Repo.get(Post, id)
  end
end
