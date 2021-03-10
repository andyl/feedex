defmodule FeedexUi.BodyEditFolderComponent do
  @moduledoc """
  Renders the body view component.

  Call using:

      <%= live_component(@socket, FeedexUi.BodyComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent
  use Phoenix.LiveEditable
  alias FeedexData.Ctx.Account.Folder
  alias FeedexData.Ctx.Account.Register
  alias FeedexData.Repo

  import Ecto.Query

  # ----- lifecycle callbacks -----

  @impl true
  def update(session, socket) do
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

  
  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <h1>EDIT FOLDER</h1>
      <table class="table">
        <tr><td>Folder Name:</td><td><%= live_edit(assigns, @folder.name, type: "text", id: "name", on_submit: "set_name") %></td></tr>
        <tr><td>Stopwords:</td><td><%= live_edit(assigns, @folder.stopwords || "NA", type: "text", id: "stopwords", on_submit: "set_stopwords") %></td></tr>
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

  # ----- view helpers -----
  
  # ----- data helpers -----
   
  # ----- event handlers -----

  def handle_event("set_name", %{"editable_text" => newname}, socket) do
    Folder
    |> Repo.get(socket.assigns.uistate.fld_id)
    |> Ecto.Changeset.change(name: newname)
    |> Repo.update()

    new_state =
      socket.assigns.uistate
      |> Map.merge(%{mode: "view"})

    # FeedexUi.Endpoint.broadcast_from(self(), "tree_mod", "rename_folder", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: new_state})}
  end

  def handle_event("set_stopwords", %{"editable_text" => new_words}, socket) do
    cleanwords =
      case new_words do
        "" ->
          nil

        words ->
          words
          |> String.split("|")
          |> Enum.map(&String.trim/1)
          |> Enum.map(&String.downcase/1)
          |> Enum.sort()
          |> Enum.uniq()
          |> Enum.join("|")
      end

    Folder
    |> Repo.get(socket.assigns.uistate.fld_id)
    |> Ecto.Changeset.change(stopwords: cleanwords)
    |> Repo.update()

    new_state =
      socket.assigns.uistate
      |> Map.merge(%{mode: "view"})

    # FeedexUi.Endpoint.broadcast_from(self(), "tree_mod", "rename_folder", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: new_state})}
  end

  def handle_event("delete", _payload, socket) do
    Repo.get(Folder, socket.assigns.uistate.fld_id)
    |> Repo.delete()

    new_state =
      socket.assigns.uistate
      |> Map.merge(%{fld_id: nil, mode: "view"})

    # FeedexUi.Endpoint.broadcast_from(self(), "tree_mod", "remove_folder", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: new_state})}
  end
end
