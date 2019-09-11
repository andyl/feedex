defmodule RaggedWeb.News.BodyView do
  alias RaggedData.Ctx.News
  alias Phoenix.HTML

  use Phoenix.LiveView

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    opts = %{
      uistate: session.uistate,
      post_id: nil
    }
    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    ~L"""
    <div>
    <table class="table table-sm">
    <%= for post <- posts_for(@uistate) do %>
    <%= if @uistate.pst_id == post.id do %>
      <tr style='background-color: lightgrey;'>
      <td><small><i class="fa fa-check"></i></small></td>
      <td><b><%= HTML.raw id_link(post.id) %></b></td>
      <td><b><a href='<%= post.link %>' target='_blank'><%= post.title %></a></b></td>
      </tr>
      <tr style='background-color: lightgrey;'><td colspan=3>
      <small>
      <%= HTML.raw post.body %>
      </small>
      </td></tr>
    <% else %>
      <tr>
      <td>
      <%= if post.has_read == "t", do: HTML.raw "<small><i class='fa fa-check'></i></small> " %>
      </td>
      <td><%= HTML.raw id_link(post.id) %></td>
      <td>
      <%= post.title %>
      </td>
      </tr>
    <% end %>
    <% end %>
    </table>
    </div>
    """
  end

  # ----- view helpers -----
  
  def id_link(id) do
    """
    <a href="#" phx-click='click-post' phx-value='#{id}'>
    #{id}
    </a>
    """
  end

  def posts_for(uistate) do
    userid = uistate.usr_id
    case {uistate.fld_id, uistate.reg_id} do
      {nil, nil   } -> News.posts_all(userid)
      {fld_id, nil} -> News.posts_for_folder(userid, fld_id)
      {nil, reg_id} -> News.posts_for_register(userid, reg_id)
    end
  end

  # ----- event handlers -----

  def handle_event("click-post", payload, socket) do
    uistate = socket.assigns.uistate
    user_id = uistate.usr_id
    post_id = String.to_integer(payload)
    new_id  = if uistate.pst_id == post_id, do: nil, else: post_id
    opts =  %{pst_id: new_id}
    newstate = 
      socket.assigns.uistate
      |> Map.merge(opts)

    RaggedData.Ctx.Account.mark_read(user_id, post_id)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "CLICK_POST", %{uistate: newstate})
    {:noreply, assign(socket, %{uistate: newstate})}
  end
  
  # ----- pub/sub handlers -----

  def handle_info(%{topic: "uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end
end
