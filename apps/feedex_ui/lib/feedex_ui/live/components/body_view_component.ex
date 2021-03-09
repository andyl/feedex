defmodule FeedexUi.BodyViewComponent do
  @moduledoc """
  Renders the body view component.

  Call using:

      <%= live_component(@socket, FeedexUi.BodyViewComponent, uistate: @uistate) %>

  """

  alias FeedexData.Ctx.News
  alias Phoenix.HTML

  use Phoenix.LiveComponent

  def update(session, socket) do
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
      <table class="text-sm table-auto">
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
              <%= if post.read_log, do: HTML.raw "<i class='fa fa-check'></i> " %>
              </td>
              <td><%= id_link(post.id) %></td>
              <td class='truncate'>
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

  def id_link(id) do
    """
    <a href="#" phx-click='click-post' phx-value-pstid='#{id}'>
    #{id}
    </a>
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


  def byline(post) do
    """
    <a href='#' phx-click='fld-clk' phx-value-fldid=#{post.fld_id}>#{post.fld_name}</a> 
    > 
    <a href='#' phx-click='reg-clk' phx-value-regid=#{post.reg_id}>#{post.reg_name}</a> (#{host_for(post)})
    """ |> HTML.raw()
  end

  defp all_posts_for(uistate) do
    userid = uistate.usr_id
    case {uistate.fld_id, uistate.reg_id} do
      {nil, nil   } -> News.posts_for(userid)
      {fld_id, nil} -> News.posts_for(userid, fld_id: fld_id)
      {nil, reg_id} -> News.posts_for(userid, reg_id: reg_id)
    end
  end

end
