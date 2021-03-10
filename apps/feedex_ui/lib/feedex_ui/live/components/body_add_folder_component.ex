defmodule FeedexUi.BodyAddFolderComponent do
  @moduledoc """
  Renders the body view component.

  Call using:

      <%= live_component(@socket, FeedexUi.BodyComponent, uistate: @uistate) %>

  """

  alias FeedexData.Ctx.Account
  alias FeedexData.Repo

  import Phoenix.HTML.Form
  import FeedexUi.ErrorHelpers

  use Phoenix.LiveComponent

  # import FeedexUi.IconHelpers

  # ----- lifecycle callbacks -----

  @impl true
  def update(session, socket) do
    opts = %{
      changeset: Account.Folder.new_changeset(),
      uistate: session.uistate
    }
    {:ok, assign(socket, opts)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>
    <H1>Create a new Folder</H1>
    <div>
    <%= f = form_for @changeset, "#", [phx_target: "#{@myself}", phx_change: :validate, phx_submit: :save] %>
    
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
    </div>
    """
  end

  # ----- event handlers -----

  @impl true
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

  @impl true
  def handle_event("save", payload, socket) do
    userid = socket.assigns.uistate.usr_id
    name   = payload["folder"]["name"]
    params = %Account.Folder{user_id: userid, name: name}
    Repo.insert(params)
    new_state = 
      socket.assigns.uistate
      |> Map.merge(%{mode: "view", fld_id: nil, reg_id: nil})
      Map.merge(socket.assigns.uistate, params)
    send(self(), "mod_tree")
    {:noreply, assign(socket, %{uistate: new_state})}
  end

end
