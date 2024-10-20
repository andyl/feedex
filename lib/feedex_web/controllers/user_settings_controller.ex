defmodule FeedexWeb.UserSettingsController do
  use FeedexWeb, :controller

  alias Feedex.Api.SubTree

  def subs_json(conn, _params) do
    subs = conn |> current_user_id() |> SubTree.list()
    json(conn, subs)
  end

  def subs(conn, _params) do
    subs = conn |> current_user_id() |> SubTree.list()

    conn
    |> assign(:subs, subs)
    |> render(:subs)
  end

  defp current_user_id(conn) do
    conn.assigns.current_user.id
  end
end
