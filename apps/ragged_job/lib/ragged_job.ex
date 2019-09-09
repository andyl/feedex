defmodule RaggedJob do
  alias RaggedData.Repo
  alias RaggedData.Ctx.News.Post

  @moduledoc """
  Fetches post data for an RSS feed.
  """

  @doc """
  Fetch data from URL, update Post records.
  """
  def sync(feed) do
    case RaggedClient.scan(feed.url) do
      {:ok, _url, data} -> sync_posts(feed.id, data)
      {:error, message} -> {:error, message}
    end
  end

  defp sync_posts(feed_id, data) do
    data.entries |> Enum.each(&(sync_post(feed_id, &1)))
    :ok
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
