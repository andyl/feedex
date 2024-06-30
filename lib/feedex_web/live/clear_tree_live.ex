defmodule FeedexWeb.ClearTreeLive do
  @moduledoc """
  This LiveView is for importing a JSON data structure with subscription settings.
  """

  use FeedexWeb, :live_view

  # ----- lifecycle callbacks -----

  @impl true
  def mount(_params, session, socket) do
    user = FeedexWeb.SessionUtil.user_from_session(session)

    opts = %{
      result: "OK",
      current_user: user
    }

    {:ok, assign(socket, opts)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>CLEAR ALL FEEDS</h1>
      <p class="action-warn">WARNING DANGER</p>
      <button class="big-button" phx-click="clear">CLICK TO DELETE ALL FEEDS</button>
      <p class="action-warn">WARNING DANGER</p>
      <hr class="m-10"/>
    </div>
    """
  end

  # ----- view helpers -----

  # ----- data helpers -----

  # ----- message handlers -----

  # ----- event handlers -----

  alias Feedex.Ctx.Account.{Folder, Register, ReadLog}
  alias Feedex.Ctx.News.{Feed, Post}
  alias Feedex.Repo

  @impl true
  def handle_event("clear", _session, socket) do
    user = socket.assigns.current_user

    IO.puts("-------------------------------")
    IO.puts("CLEARING FEEDS")
    IO.puts("USER ID #{user.id}")

    Repo.delete_all(ReadLog)
    Repo.delete_all(Register)
    Repo.delete_all(Folder)
    Repo.delete_all(Post)
    Repo.delete_all(Feed)

    {:noreply, socket}
  end
end
