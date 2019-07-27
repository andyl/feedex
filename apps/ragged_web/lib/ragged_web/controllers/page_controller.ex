defmodule RaggedWeb.PageController do
  use RaggedWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
