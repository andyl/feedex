defmodule FcRss.UrlCheck do
  @url_regex ~r/^(https?:\/\/)?([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,}(\/[a-zA-Z0-9\-._~:\/?#\[\]@!$&'()*+,;=%]*)?$/

  def valid_url?(url) when is_binary(url) do
    Regex.match?(@url_regex, url)
  end

  def valid_url?(_), do: false
end
