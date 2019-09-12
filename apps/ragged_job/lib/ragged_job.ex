defmodule RaggedJob do
  alias RaggedData.Repo
  alias RaggedData.Ctx.News.Post
  alias RaggedData.Ctx.News.Feed

  import Ecto.Query

  @moduledoc """
  Fetches post data for an RSS feed.
  """

  @doc """
  Fetch data from URL, update Post records.
  """
  def sync(feed) do
    case RaggedClient.scan(feed.url) do
      {:ok, _url, data} -> sync_posts(feed, data)
      {:error, message} -> {:error, message}
    end
  end

  def sync_next do
    Feed
    |> order_by(:updated_at)
    |> limit(1)
    |> Repo.one()
    |> sync()
  end

  def sync_all do
    Feed
    |> Repo.all()
    |> Enum.map(&(sync(&1)))
  end

  defp sync_posts(feed, data) do
    data.entries |> Enum.each(&(sync_post(feed.id, &1)))
    mark_updated(feed)
    :ok
  end

  defp mark_updated(feed) do
    "update feeds set updated_at = now() where id = #{feed.id}"
    |> Repo.query()
  end

  defp sync_post(feed_id, post) do
    opts = %Post{
      exid:    post.id,
      title:   post.title,
      body:    post[:description] || post[:content],
      author:  author_for(post),
      link:    post[:"rss2:link"],
      feed_id: feed_id
    }
    Repo.get_by(Post, exid: opts.exid) || Repo.insert!(opts)
  end

  defp author_for(post) do
    post[:author] || Enum.join(post[:authors] || [])
  end
end
