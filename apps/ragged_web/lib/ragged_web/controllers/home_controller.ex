defmodule RaggedWeb.HomeController do
  use RaggedWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end

  def demo(conn, _params) do
    render(conn, "demo.html")
  end

  def signup(conn, _params) do
    render(conn, "signup.html")
  end
end
