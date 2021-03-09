defmodule FeedexUi.NewsLive do
  @moduledoc """
  Renders the news page.
  """

  use FeedexUi, :live_view
  alias FeedexUi.Cache.UiState

  # ----- lifecycle callbacks -----

  @impl true
  def mount(_params, session, socket) do
    user = FeedexUi.SessionUtil.user_from_session(session)
    treemap = FeedexData.Ctx.Account.cleantree(user.id)

    opts = %{
      current_user: user,
      uistate: UiState.lookup(user.id),
      treemap: treemap,
      counts: gen_counts(user.id)
    }

    {:ok, assign(socket, opts)}
  end

  @impl true
  def handle_params(_unsigned_params, uri, socket) do
    {:noreply, assign(socket, path: URI.parse(uri).path)}
  end

  # ----- data helpers -----

  def gen_counts(user_id) do
    %{
      all: FeedexData.Ctx.News.unread_count_for(user_id),
      fld: FeedexData.Ctx.News.unread_aggregate_count_for(user_id, type: "fld"),
      reg: FeedexData.Ctx.News.unread_aggregate_count_for(user_id, type: "reg")
    }
  end

  # ----- message handlers -----
  
  @impl true
  def handle_info({"set_uistate", %{uistate: new_state}}, socket) do
    {:noreply, assign(socket, uistate: new_state)}
  end

  @impl true
  def handle_info("mark_all_read", socket) do

    opts = %{
      counts: gen_counts(socket.assigns.current_user.id)
    }

    {:noreply, assign(socket, opts)}
  end

end
