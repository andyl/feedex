defmodule FeedexWeb.LiveHelpers do
  def path_for(url) do
    parsed_url = URI.parse(url)
    parsed_url.path
  end
end
