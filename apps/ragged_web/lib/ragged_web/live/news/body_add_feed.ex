defmodule RaggedWeb.News.BodyAddFeed do
  alias RaggedData.Ctx.Account
  alias RaggedData.Ctx.Account.Folder 
  alias RaggedData.Ctx.Account.Register
  alias RaggedData.Ctx.News.Feed
  alias RaggedData.Repo

  import Phoenix.HTML.Form
  import RaggedWeb.ErrorHelpers
  import Ecto.Query

  use Phoenix.LiveView

  def mount(session, socket) do
    opts = %{
      changeset: Account.RegFeed.new_changeset(),
      uistate: session.uistate
    }
    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    ~L"""
    <div>
    <H1>Create a new Feed</H1>
    <div>
    <%= f = form_for @changeset, "#", [phx_change: :validate, phx_submit: :save] %>
    
      <div class="form-group">
        <%= text_input f, :name, placeholder: "Enter a feed name...", class: "form-control" %>
        <%= error_tag f, :name %>
      </div>

      <div class="form-group">
        <%= text_input f, :url, placeholder: "Enter a url...", class: "form-control" %>
        <%= error_tag f, :url %>
      </div>

      <div class="form-group">
        <%= select f, :folder_id, folders_for(@uistate), class: "form-control" %>
      </div>

      <%= if @changeset.valid? do %>
        <%= submit "Create a Feed", class: "btn btn-primary" %>
      <% else %>
        <button style='pointer-events: none;' class="btn btn-primary disabled">Create a Feed</button>
      <% end %>
    </form>

    </div>
    </div>
    """
  end

  # ----- view helpers -----
    
  def folders_for(uistate) do
    user_id = uistate.usr_id
    from(
      f in Folder,
      where: f.user_id == ^user_id
    ) 
    |> Repo.all()
    |> Enum.map(fn(el) -> {el.name, el.id} end)
  end
  
  # ----- event handlers -----
  
  def handle_event("validate", payload, socket) do
    params = %{
      name: payload["reg_feed"]["name"],
      url:  payload["reg_feed"]["url"]
    }
    changeset = 
      %Account.RegFeed{}
      |> Account.RegFeed.changeset(params)
    opts = %{
      changeset: changeset,
    }
    {:noreply, assign(socket, opts)}
  end

  # if the feed exists, use that.  
  # otherwise create a feed.
  # then create a register
  # finally, redirecto to the reg/feed
  def handle_event("save", payload, socket) do
    url  = payload["reg_feed"]["url"]
    {:ok, feed} = feed_for(url)
    {:ok, reg}  = %Register{
      name:      payload["reg_feed"]["name"],
      feed_id:   feed.id,
      folder_id: String.to_integer(payload["reg_feed"]["folder_id"])
    } |> Repo.insert()
    new_state = 
      socket.assigns.uistate
      |> Map.merge(%{mode: "view", fld_id: nil, reg_id: reg.id})
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "create_feed", %{uistate: new_state})
    {:noreply, socket}
  end

  defp feed_for(url) do
    Repo.get_by(Feed, url: url) || Repo.insert(%Feed{url: url})
  end
  
  # ----- pub/sub handlers -----

  def handle_info(_params, socket) do
    {:noreply, socket}
  end
end
