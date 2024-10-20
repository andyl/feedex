defmodule FeedexWeb.BodyViewComponent do
  @moduledoc """
  Renders the body view component.

  Call using:

      <%= live_component(@socket, FeedexUi.BodyViewComponent, uistate: @uistate) %>

  """

  alias Feedex.Ctx.News
  alias Phoenix.HTML

  use Phoenix.LiveComponent

  import FeedexWeb.BootstrapIconHelpers
  import FeedexWeb.AppComponents

  # ----- lifecycle callbacks -----

  @impl true
  def update(session, socket) do
    opts = %{
      uistate: session.uistate,
      counts: session.counts,
      posts: all_posts_for(session.uistate)
    }

    {:ok, assign(socket, opts)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <table class="table-auto">
        <%= for post <- @posts do %>
          <%= if @uistate.pst_id == post.id do %>
            <tr class="bg-slate-300">
              <td><%= check_svg("inline px-1 h-3", :raw) %></td>
              <td><b><%= id_link(post.id, @myself) %></b></td>
              <td>
                <b>
                  <.alink href={post.link} {%{target: "_blank"}}>
                    <%= time_ago(post.updated_at) %><%= post.title %>
                  </.alink>
                </b>
              </td>
            </tr>
            <tr class="bg-slate-300">
              <td></td>
              <td></td>
              <td>
                <small>
                  <%= byline(post) %> <%= HTML.raw(post.body) %>
                </small>
              </td>
            </tr>
          <% else %>
            <tr class="border-b decoration-slate-300">
              <td>
                <%= if post.read_log, do: check_svg("inline px-1 h-3", :raw) %>
              </td>
              <td class="align-top"><%= id_link(post.id, @myself) %></td>
              <td class="">
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

  def id_link(id, myself) do
    """
    <a href="#" class="px-2 text-blue-400 hover:text-blue-800" phx-target='#{myself}' phx-click='click-post' phx-value-pstid='#{id}'>
    #{id}
    </a>
    """
    |> HTML.raw()
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

    base =
      case delta do
        x when x in 0..60 -> "#{x}m"
        x when x in 61..1440 -> "#{div(x, 60)}h"
        x when x in 1441..10_080 -> "#{div(x, 1440)}d"
        x when x in 10_081..99_999 -> "#{div(x, 10_080)}w"
        _ -> "xx"
      end

    "#{base} - "
  end

  def byline(post) do
    """
    <a href='#' class='bluelink' phx-click='fld-clk' phx-value-fldid=#{post.fld_id}>#{post.fld_name}</a>
    >
    <a href='#' phx-click='reg-clk' phx-value-regid=#{post.reg_id}>#{post.reg_name}</a> (#{host_for(post)})
    """
    |> HTML.raw()
  end

  # ----- data helpers -----

  defp all_posts_for(uistate) do
    userid = uistate.usr_id

    case {uistate.fld_id, uistate.reg_id} do
      {nil, nil} -> News.posts_for(userid)
      {fld_id, nil} -> News.posts_for(userid, fld_id: fld_id)
      {nil, reg_id} -> News.posts_for(userid, reg_id: reg_id)
    end
  end

  # ----- event handlers -----

  @impl true
  def handle_event("click-post", %{"pstid" => pstid}, socket) do
    # Toggle post on and off...
    uistate = socket.assigns.uistate
    user_id = uistate.usr_id
    post_id = String.to_integer(pstid)
    new_pid = if uistate.pst_id == post_id, do: nil, else: post_id
    newstate = Map.merge(uistate, %{pst_id: new_pid})

    if new_pid do
      Feedex.Ctx.Account.mark_all_for(user_id, pst_id: post_id)
    end

    send(self(), {"set_uistate", %{uistate: newstate}})

    {:noreply, assign(socket, %{uistate: newstate})}
  end
end
