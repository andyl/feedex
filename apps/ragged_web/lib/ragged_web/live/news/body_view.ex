defmodule RaggedWeb.News.BodyView do
  alias RaggedData.Ctx.News
  alias Phoenix.HTML

  use Phoenix.LiveView

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("set_uistate")
    RaggedWeb.Endpoint.subscribe("read_all")
    opts = %{
      uistate: session.uistate,
      posts: all_posts_for(session.uistate),
      post_id: nil
    }
    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    ~L"""
    <div>
    <table class="table table-sm">
    <%= for post <- @posts do %>
    <%= if @uistate.pst_id == post.id do %>
      <tr style='background-color: lightgrey;'>
      <td><small><i class="fa fa-check"></i></small></td>
      <td><b><%= id_link(post.id) %></b></td>
      <td><b><a href='<%= post.link %>' target='_blank'><%= time_ago(post.updated_at) %><%= post.title %></a></b></td>
      </tr>
      <tr style='background-color: lightgrey;'><td colspan=3>
      <small>
      <%= HTML.raw post.body %>
      </small>
      </td></tr>
    <% else %>
      <tr>
      <td>
      <%= if post.read_log, do: HTML.raw "<small><i class='fa fa-check'></i></small> " %>
      </td>
      <td><%= id_link(post.id) %></td>
      <td>
      <%= time_ago(post.updated_at) %><%= post.title %>
      </td>
      </tr>
    <% end %>
    <% end %>
    </table>
    </div>
    """
  end

  # ----- view helpers -----
  
  def time_ago(date) do
    delta = Timex.diff(Timex.now(), date, :minutes)
    base  = case delta do
      x when x in 0..60        -> "#{x}m"
      x when x in 61..1440     -> "#{div(x, 60)}h"
      x when x in 1441..10080  -> "#{div(x, 1440)}d"
      x when x in 10081..99999 -> "#{div(x, 10080)}w"
      _ -> "xx"
    end
    "#{base} - "
  end

  def id_link(id) do
    """
    <a href="#" phx-click='click-post' phx-value-pstid='#{id}'>
    #{id}
    </a>
    """ |> HTML.raw()
  end

  def all_posts_for(uistate) do
    userid = uistate.usr_id
    case {uistate.fld_id, uistate.reg_id} do
      {nil, nil   } -> News.posts_for(userid)
      {fld_id, nil} -> News.posts_for(userid, fld_id: fld_id)
      {nil, reg_id} -> News.posts_for(userid, reg_id: reg_id)
    end
  end

  # ----- event handlers -----

  def handle_event("click-post", %{"pstid" => pstid}, socket) do
    # Toggle post on and off...
    uistate = socket.assigns.uistate
    user_id = uistate.usr_id
    post_id = String.to_integer(pstid)
    new_id  = if uistate.pst_id == post_id, do: nil, else: post_id
    opts =  %{pst_id: new_id}
    newstate = 
      socket.assigns.uistate
      |> Map.merge(opts)

    if new_id do
      RaggedData.Ctx.Account.mark_all_for(user_id, pst_id: post_id)
      RaggedWeb.Endpoint.broadcast_from(self(), "read_one", "CLICK_POST", %{})
    end

    {:noreply, assign(socket, %{uistate: newstate})}
  end
  
  # ----- pub/sub handlers -----

  def handle_info(%{topic: "set_uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end

  def handle_info(%{topic: "read_all"}, socket) do
    uistate = socket.assigns.uistate
    {:noreply, assign(socket, %{posts: all_posts_for(uistate)})}
  end
end
