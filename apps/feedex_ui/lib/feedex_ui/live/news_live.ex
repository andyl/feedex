defmodule FeedexUi.NewsLive do
  @moduledoc """
  Renders the news page.
  """

  use FeedexUi, :live_view
  alias FeedexUi.Cache.UiState

  @impl true
  def mount(_params, session, socket) do
    user = FeedexUi.LiveUtil.user_from_session(session)
    opts = %{
      current_user: user,
      uistate: UiState.lookup(user.id),
      treemap: FeedexData.Ctx.Account.cleantree(user.id),
      counts: gen_counts(user.id)
    }
    {:ok, assign(socket, opts)}
  end

  @impl true
  def handle_params(_unsigned_params, uri, socket) do
    {:noreply, assign(socket, path: URI.parse(uri).path)}
  end

  # ----- view helpers -----

  def gen_counts(user_id) do
    %{
      all: FeedexData.Ctx.News.unread_count_for(user_id),
      fld: FeedexData.Ctx.News.unread_aggregate_count_for(user_id, type: "fld"),
      reg: FeedexData.Ctx.News.unread_aggregate_count_for(user_id, type: "reg")
    }
  end

  # ----- callbacks -----

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  @impl true
  def handle_info({:tick, assigns}, socket) do
    send_update(FeedexUi.ClockComponent, assigns)
    {:noreply, socket}
  end

  @impl true
  def handle_info({"set_uistate", %{uistate: new_state}}, socket) do
    opts = [
      uistate: new_state,
      id: "hdr"
    ]
    send_update(FeedexUi.HdrComponent, opts)
    {:noreply, socket}
  end

  defp search(query) do
    if not FeedexUi.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
