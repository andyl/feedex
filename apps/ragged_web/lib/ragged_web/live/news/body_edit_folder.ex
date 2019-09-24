defmodule RaggedWeb.News.BodyEditFolder do
  alias RaggedData.Ctx.Account.Folder
  alias RaggedData.Ctx.Account.Register
  alias RaggedData.Repo

  import Ecto.Query

  use Phoenix.LiveView
  use Phoenix.LiveEditable

  def mount(session, socket) do
    folder_id = session.uistate.fld_id
    reg_count = 
      from(r in Register, select: count(r.id), where: r.folder_id == ^folder_id)
      |> Repo.one()
    opts = %{
      folder: Repo.get(Folder, folder_id),
      feed_count: reg_count,
      uistate: session.uistate
    }
    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    ~L"""
    <div>
    <h1>EDIT FOLDER</h1>
    <table class="table">
    <tr><td>Folder Name:</td><td><%= live_edit(assigns, @folder.name, type: "text", id: "name", on_submit: "rename") %></td></tr>
    <tr><td>Folder ID:</td><td><%= @folder.id %></td></tr>
    <tr><td>Num Feeds:</td><td><%= @feed_count %></td></tr>
    </table>
    <p style='margin-bottom: 60px;'></p>
    <%= if @feed_count == 0 do %>
    <button type="button" phx-click='delete' class="btn btn-danger">Delete Folder</button>
    <% end %>
    </div>
    """
  end
  
  # ----- event handlers -----

  def handle_event("rename", %{"editable_text" => newname}, socket) do
    Folder
    |> Repo.get(socket.assigns.uistate.fld_id)
    |> Ecto.Changeset.change(name: newname)
    |> Repo.update()
    new_state = 
      socket.assigns.uistate
      |> Map.merge(%{mode: "view"})
    RaggedWeb.Endpoint.broadcast_from(self(), "tree_mod", "rename_folder", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: new_state})}
  end

  def handle_event("delete", _payload, socket) do
    Repo.get(Folder, socket.assigns.uistate.fld_id)
    |> Repo.delete()
    new_state = 
      socket.assigns.uistate
      |> Map.merge(%{fld_id: nil, mode: "view"})
    RaggedWeb.Endpoint.broadcast_from(self(), "tree_mod", "remove_folder", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: new_state})}
  end
  
  # ----- pub/sub handlers -----

  def handle_info(_params, socket) do
    {:noreply, socket}
  end
end
