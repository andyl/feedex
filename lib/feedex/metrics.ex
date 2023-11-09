defmodule Feedex.Metrics do

  alias Feedex.Ctx.News
  alias Feedex.Ctx.Account

  def count do
    %{
      users: user_count(),
      folders: folder_count(),
      feeds: feed_count(),
      posts: post_count(),
      unread: unread_count(),
    }
  end

  def user_count do
    Account.user_count()
  end

  def folder_count do
    News.folder_count()
  end

  def feed_count do
    News.feed_count()
  end

  def post_count do
    News.post_count()
  end

  def unread_count do
    News.unread_count()
  end

end
