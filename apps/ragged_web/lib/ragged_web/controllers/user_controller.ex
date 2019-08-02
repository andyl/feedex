defmodule RaggedWeb.UserController do
  use RaggedWeb, :controller

  alias RaggedData.Ctx.Account
  alias RaggedData.Ctx.Account.User

  plug :authenticate when action in [:index, :show]

  def index(conn, _params) do
    users = Account.user_list()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Account.user_get(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = Account.user_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Account.user_signup(user_params) do
      {:ok, user} ->
        conn
        |> RaggedWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
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
