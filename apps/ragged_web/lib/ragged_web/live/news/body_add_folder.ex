defmodule RaggedWeb.News.BodyAddFolder do
  alias RaggedData.Ctx.Account
  alias RaggedData.Repo

  import Phoenix.HTML.Form
  import RaggedWeb.ErrorHelpers
  use Phoenix.LiveView

  def mount(session, socket) do
    opts = %{
      changeset: Account.Folder.new_changeset(),
      uistate: session.uistate
    }
    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    ~L"""
    <H1>Create a new Folder</H1>
    <div>
    <%= f = form_for @changeset, "#", [phx_change: :validate, phx_submit: :save] %>
    
      <div class="form-group">
        <%= text_input f, :name, placeholder: "Enter a folder name...", class: "form-control" %>
        <%= error_tag f, :name %>
      </div>

      <%= if @changeset.valid? do %>
        <%= submit "Create a Folder", class: "btn btn-primary" %>
      <% else %>
        <button style='pointer-events: none;' class="btn btn-primary disabled">Create a Folder</button>
      <% end %>
    </form>

    </div>
    """
  end

  # ----- event handlers -----
  
  def handle_event("validate", payload, socket) do
    params = %{name: payload["folder"]["name"]}
    changeset = 
      %Account.Folder{}
      |> Account.Folder.changeset(params)
    opts = %{
      changeset: changeset,
    }
    {:noreply, assign(socket, opts)}
  end

  def handle_event("save", payload, socket) do
    userid = socket.assigns.uistate.usr_id
    name   = payload["folder"]["name"]
    params = %Account.Folder{user_id: userid, name: name}
    Repo.insert(params)
    new_state = 
      socket.assigns.uistate
      |> Map.merge(%{mode: "view", fld_id: nil, reg_id: nil})
      Map.merge(socket.assigns.uistate, params)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "create_folder", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: new_state})}
  end
  
  # ----- pub/sub handlers -----

  def handle_info(_params, socket) do
    {:noreply, socket}
  end
end
