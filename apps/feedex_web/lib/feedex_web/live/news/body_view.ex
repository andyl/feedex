defmodule FeedexWeb.News.BodyView do
  alias FeedexData.Ctx.News
  alias Phoenix.HTML

  use Phoenix.LiveView

  def mount(session, socket) do
    FeedexWeb.Endpoint.subscribe("set_uistate")
    FeedexWeb.Endpoint.subscribe("read_all")
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
      <%= byline(post) %> <%= HTML.raw post.body %>
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
  
  def byline(post) do
    """
    <a href='#' phx-click='fld-clk' phx-value-fldid=#{post.fld_id}>#{post.fld_name}</a> 
    > 
    <a href='#' phx-click='reg-clk' phx-value-regid=#{post.reg_id}>#{post.reg_name}</a> (#{host_for(post)})
    """ |> HTML.raw()
  end

  def host_for(post) do
    URI.parse(post.link).host
    |> String.replace("co.uk", "couk")
    |> String.replace("com.br", "combr")
    |> String.split(".") 
    |> Enum.take(-2) 
    |> List.first()
  end
  
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
      FeedexData.Ctx.Account.mark_all_for(user_id, pst_id: post_id)
      FeedexWeb.Endpoint.broadcast_from(self(), "read_one", "CLICK_POST", %{})
    end

    posts = all_posts_for(socket.assigns.uistate)

    {:noreply, assign(socket, %{posts: posts, uistate: newstate})}
  end

  def handle_event("fld-clk", %{"fldid" => fldid}, socket) do
    opts = %{
      fld_id: Integer.parse(fldid) |> elem(0),
      reg_id: nil
    }
    new_state = Map.merge(socket.assigns.uistate, opts)
    FeedexWeb.Endpoint.broadcast_from(self(), "set_uistate", "POSTCLK_FLD", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: new_state})}
  end
  
  def handle_event("reg-clk", %{"regid" => regid}, socket) do
    opts = %{
      reg_id: Integer.parse(regid) |> elem(0),
      fld_id: nil
    }
    new_state = Map.merge(socket.assigns.uistate, opts)
    FeedexWeb.Endpoint.broadcast_from(self(), "set_uistate", "POSTCLK_REG", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: new_state})}
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
