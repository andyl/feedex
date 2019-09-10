defmodule RaggedWeb.News.BodyEditFolder do
  alias RaggedData.Ctx.Account.Folder
  alias RaggedData.Ctx.Account.Register
  alias RaggedData.Repo

  import Ecto.Query

  use Phoenix.LiveView

  def mount(session, socket) do
    folder_id = session.uistate.fld_id
    reg_count = 
      from(r in Register, select: count(r.id), where: r.id == ^folder_id)
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
    Folder Name: <%= @folder.name %><br/>
    Folder ID: <%= @folder.id %><br/>
    Num Feeds: <%= @feed_count %>
    <p>
    <%= if @feed_count == 0 do %>
    <a href='#' phx-click='delete'>Delete Folder</a>
    <% end %>
    </p>
    </div>
    """
  end
  
  # ----- event handlers -----

  def handle_event("delete", _payload, socket) do
    Repo.get(Folder, socket.assigns.uistate.fld_id)
    |> Repo.delete()
    new_state = 
      socket.assigns.uistate
      |> Map.merge(%{fld_id: nil, mode: "view"})
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "remove_folder", %{uistate: new_state})
    {:noreply, socket}
  end
  
  # ----- pub/sub handlers -----

  def handle_info(_params, socket) do
    {:noreply, socket}
  end
end
