defmodule FeedexWeb.PageController do
  use FeedexWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
