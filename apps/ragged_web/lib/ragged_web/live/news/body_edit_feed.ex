defmodule RaggedWeb.News.BodyEditFeed do
  alias RaggedData.Ctx.News.Post
  alias RaggedData.Ctx.News.Feed
  alias RaggedData.Ctx.Account.Register
  alias RaggedData.Ctx.Account.Folder
  alias RaggedData.Repo

  import Ecto.Query
  import Phoenix.HTML

  use Phoenix.LiveView
  use Phoenix.LiveEditable

  require Logger

  def mount(session, socket) do
    reg_id = session.uistate.reg_id
    usr_id = session.uistate.usr_id
    register = Repo.get(Register, reg_id)

    opts =
      if register do
        feed_count =
          from(reg in Register, select: count(reg.id), where: reg.feed_id == ^register.feed_id)
          |> Repo.one()

        post_count =
          from(pst in Post, select: count(pst.id), where: pst.feed_id == ^register.feed_id)
          |> Repo.one()

        folders = from(fld in Folder, 
          select: {fld.id, fld.name}, 
          where: fld.user_id == ^usr_id,
          order_by: fld.name
        ) |> Repo.all() 

        %{
          register: register,
          feed_count: feed_count,
          feed: Repo.get(Feed, register.feed_id),
          folder: Repo.get(Folder, register.folder_id), 
          folders: folders,
          post_count: post_count,
          uistate: session.uistate
        }
      else
        %{
          register: nil,
          feed_count: 0,
          feed: nil,
          folder: nil,
          folders: nil,
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
      <tr><td>Reg Name:</td><td><%= live_edit(assigns, @register.name, type: "text", id: "name", on_submit: "rename") %></td></tr>
      <tr><td>Reg Folder:</td><td><%= live_edit(assigns, @folder.name, type: "select", options: @folders, id: "folder", on_submit: "refolder") %></td></tr>
      <tr><td>FeedUrl:</td><td><%= feed_link(@feed) %></td></tr>
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

  # ----- view helpers -----

  def feed_link(feed) do
    """
    <a href="#{feed.url}" target="_blank">
    #{feed.url}
    </a>
    """ |> raw()
  end

  # ----- event handlers -----

  def handle_event("delete", _payload, socket) do
    register = Repo.get(Register, socket.assigns.uistate.reg_id)

    feed_count =
      from(r in Register, select: count(r.id), where: r.feed_id == ^register.feed_id)
      |> Repo.one()

    try do
    if feed_count == 1 do
      Repo.get(Feed, register.feed_id) |> Repo.delete()
    end
    rescue
      _ -> Logger.info("Warning: delete feed error")
    end

    try do
    Repo.delete(register)
    rescue
      _ -> Logger.info("Warning: delete register error")
    end

    new_state =
      socket.assigns.uistate
      |> Map.merge(%{fld_id: nil, reg_id: nil, mode: "view"})

    RaggedWeb.Endpoint.broadcast_from(self(), "tree_mod", "remove_feed", %{uistate: new_state})
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
    RaggedWeb.Endpoint.broadcast_from(self(), "tree_mod", "rename_feed", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: new_state})}
  end

  def handle_event("refolder", %{"editable_select" => fldid}, socket) do
    Register
    |> Repo.get(socket.assigns.uistate.reg_id)
    |> Ecto.Changeset.change(folder_id: String.to_integer(fldid))
    |> Repo.update()
    new_state = 
      socket.assigns.uistate
      |> Map.merge(%{mode: "view"})
    RaggedWeb.Endpoint.broadcast_from(self(), "tree_mod", "rename_feed", %{uistate: new_state})
    {:noreply, socket |> assign(%{uistate: new_state})}
  end

  # ----- pub/sub handlers -----

  def handle_info(_params, socket) do
    {:noreply, socket}
  end
end
