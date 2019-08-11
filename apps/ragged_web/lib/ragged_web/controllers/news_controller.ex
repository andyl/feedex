defmodule RaggedWeb.NewsController do
  use RaggedWeb, :controller

  alias RaggedWeb.Data.UiState

  plug :authenticate when action in [:index]

  def index(conn, _params) do
    conn
    |> assign(:uistate, uistate(conn))
    |> render("index.html")
  end

  defp uistate(conn) do
    id = conn.assigns.current_user.id
    UiState.lookup(id)
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
end
