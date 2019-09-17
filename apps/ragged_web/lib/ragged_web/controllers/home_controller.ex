defmodule RaggedWeb.HomeController do
  use RaggedWeb, :controller

  alias RaggedData.Api.Subs

  plug :authenticate when action in [:subs]

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

  def subs(conn, _params) do
    conn
    |> assign(:subs, Subs.show(userid(conn)))
    |> render("subs.html")
  end

  def signup(conn, _params) do
    render(conn, "signup.html")
  end

  # ----- 

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.home_path(conn, :index))
      |> halt()
    end
  end
  
  defp userid(conn) do
    conn.assigns.current_user.id
  end
end
