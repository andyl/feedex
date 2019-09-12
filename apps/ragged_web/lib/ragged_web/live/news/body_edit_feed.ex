defmodule RaggedWeb.News.BodyEditFeed do
  alias RaggedData.Ctx.News.Post
  alias RaggedData.Ctx.News.Feed
  alias RaggedData.Ctx.Account.Register
  alias RaggedData.Repo

  import Ecto.Query

  use Phoenix.LiveView

  def mount(session, socket) do
    reg_id = session.uistate.reg_id
    register = Repo.get(Register, reg_id)
    feed_count = 
      from(r in Register, select: count(r.id), where: r.feed_id == ^register.feed_id)
      |> Repo.one()
    post_count =
      from(p in Post, select: count(p.id), where: p.feed_id == ^register.feed_id)
      |> Repo.one()
    feed       = Repo.get(Feed, register.feed_id)
    opts = %{
      register: register,
      feed_count: feed_count,
      feed: feed,
      post_count: post_count,
      uistate: session.uistate
    }
    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    ~L"""
    <h1>EDIT FEED</h1>
    <b>Reg Name:</b> <%= @register.name %><br/>
    <b>Feed Url:</b> <%= @feed.url %><br/>
    <div class="row" style='margin-top: 60px;'>
    <div class="col-md-6">
    <b>Registry ID:</b> <%= @register.id %><br/>
    <b>Feed Count:</b> <%= @feed_count %><br/>
    <b>Post Count:</b> <%= @post_count %>
    </div>
    <div class="col-md-6">
    <p style='margin-bottom: 120px;'>
    <button type="button" phx-click='resync' class="btn btn-primary">Sync Feed</button>
    </p>
    <%= if @feed_count == 1 do %>
    <button type="button" phx-click='delete' class="btn btn-danger">Delete Register</button>
    <% end %>
    </div>
    </div>
    """
  end

  # ----- event handlers -----

  def handle_event("delete", _payload, socket) do
    register = Repo.get(Register, socket.assigns.uistate.reg_id)
    feed_count = from(r in Register, select: count(r.id), where: r.feed_id == ^register.feed_id)
                 |> Repo.one()
    if feed_count > 1 do
      Repo.get(Feed, register.feed_id) |> Repo.delete()
    end
    Repo.delete(register)
    new_state = 
      socket.assigns.uistate
      |> Map.merge(%{fld_id: nil, reg_id: nil, mode: "view"})
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "remove_feed", %{uistate: new_state})
    {:noreply, socket}
  end

  def handle_event("resync", _payload, socket) do
    feed = socket.assigns.feed
    RaggedJob.sync(feed)
    {:noreply, socket}
  end
  
  # ----- pub/sub handlers -----

  def handle_info(_params, socket) do
    {:noreply, socket}
  end
end
