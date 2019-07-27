defmodule RaggedClient do
  @moduledoc """
  An Elixir Client that pulls RSS Documents.
  """

  @doc """
  Probes a URL for a valid RSS feed.

  Returns the URL of a valid RSS feed.

  If the input URL does not return a valid RSS document, a number of
  alternative URL's are tested, and the URL of the first valid URL is returned.

  For example: given an input URL "http://ragged.io/myfeed.html", the following URLs will
  be tested:

  - http://ragged.io/myfeed.rss
  - http://ragged.io/myfeed/feed

  ## Examples

      iex> RaggedClient.probe("https://ragged.io")
      {:ok, "https://ragged.io"}

  """
  def probe(url) do
    {:ok, url}
  end

  @doc """
  Gets XML data for an RSS feed.

  ## Examples

      iex> RaggedClient.get("https://ragged.io/feed")
      {:ok, %{}}

  """
  def get(_url) do
    {:ok, %{}}
  end
end
