defmodule FeedexWeb.NewsController do
  use FeedexWeb, :controller

  alias FeedexWeb.Cache.UiState

  plug :authenticate when action in [:index]

  def index(conn, _params) do
    conn
    |> assign(:uistate, uistate(conn))
    |> render("index.html")
  end

  defp uistate(conn) do
    conn
    |> userid()
    |> UiState.lookup()
  end

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
