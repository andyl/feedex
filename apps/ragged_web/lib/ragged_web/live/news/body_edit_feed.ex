defmodule RaggedWeb.News.BodyEditFeed do
  alias RaggedData.Ctx.News.Post
  alias RaggedData.Ctx.News.Feed
  alias RaggedData.Ctx.Account.Register
  alias RaggedData.Repo

  import Ecto.Query

  use Phoenix.LiveView
  use LiveEdit.Base

  def mount(session, socket) do
    reg_id = session.uistate.reg_id
    register = Repo.get(Register, reg_id)

    opts =
      if register do
        feed_count =
          from(r in Register, select: count(r.id), where: r.feed_id == ^register.feed_id)
          |> Repo.one()

        post_count =
          from(p in Post, select: count(p.id), where: p.feed_id == ^register.feed_id)
          |> Repo.one()

        feed = Repo.get(Feed, register.feed_id)

        %{
          register: register,
          feed_count: feed_count,
          feed: feed,
          post_count: post_count,
          uistate: session.uistate
        }
      else
        %{
          register: nil,
          feed_count: 0,
          feed: nil,
          post_count: 0,
          changeset: %Register{},
          uistate: session.uistate
        }
      end

    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    ~L"""
    <h1>EDIT FEED</h1>
    <%= if @register do %>
      <table class="table">
      <tr><td>Reg Name:</td><td><%= live_edit(assigns, @register.name, id: "name", on_submit: "rename") %></td></tr>
      <tr><td>FeedUrl:</td><td><%= @feed.url %></td></tr>
      <tr><td>Usr/Registry ID:</td><td><%= @register.id %></td></tr>
      <tr><td>Attached Registries:</td><td><%= @feed_count %></td></tr>
      <tr><td>Post Count:</td><td><%= @post_count %></td></tr>
      <tr><td>Sync Count:</td><td><%= @feed.sync_count %></td></tr>
      </table>
    <p style='margin-bottom: 60px;'></p>
    <%= if @feed_count == 1 do %>
    <button type="button" phx-click='delete' class="btn btn-danger">Delete Feed</button>
    <% end %>
    <% end %>
    """
  end

  # ----- event handlers -----

  def handle_event("delete", _payload, socket) do
    register = Repo.get(Register, socket.assigns.uistate.reg_id)

    feed_count =
      from(r in Register, select: count(r.id), where: r.feed_id == ^register.feed_id)
      |> Repo.one()

    if feed_count == 1 do
      Repo.get(Feed, register.feed_id) |> Repo.delete()
    end

    Repo.delete(register)

    new_state =
      socket.assigns.uistate
      |> Map.merge(%{fld_id: nil, reg_id: nil, mode: "view"})

    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "remove_feed", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: new_state})}
  end

  def handle_event("rename", %{"editable_text" => newname}, socket) do
    Register
    |> Repo.get(socket.assigns.uistate.reg_id)
    |> Ecto.Changeset.change(name: newname)
    |> Repo.update()
    new_state = 
      socket.assigns.uistate
      |> Map.merge(%{mode: "view"})
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "rename_feed", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: new_state})}
  end

  # ----- pub/sub handlers -----

  def handle_info(_params, socket) do
    {:noreply, socket}
  end
end
