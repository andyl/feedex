defmodule RaggedWeb.News.BodyEditFeed do
  alias RaggedData.Ctx.News
  alias RaggedData.Ctx.News.Post
  alias RaggedData.Ctx.News.Feed
  alias RaggedData.Ctx.Account.Folder
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
    opts = %{
      register: register,
      feed_count: feed_count,
      post_count: post_count,
      uistate: session.uistate
    }
    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    ~L"""
    <div>
    <h1>EDIT FEED</h1>
    Registry Name: <%= @register.name %><br/>
    Registry ID: <%= @register.id %><br/>
    Feed Count: <%= @feed_count %><br/>
    Post Count: <%= @post_count %>
    <p>
    <%= if @feed_count == 1 do %>
    <a href='#' phx-click='delete'>Delete Register</a>
    <% end %>
    </p>
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
      |> Map.merge(%{fold_id: nil, reg_id: nil, mode: "view"})
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "remove_feed", %{uistate: new_state})
    {:noreply, socket}
  end
  
  # ----- pub/sub handlers -----

  def handle_info(_params, socket) do
    {:noreply, socket}
  end
end
