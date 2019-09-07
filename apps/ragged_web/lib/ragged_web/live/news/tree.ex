defmodule RaggedWeb.News.Tree do
  
  use Phoenix.LiveView

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    {:ok, assign(socket, %{uistate: session.uistate, treemap: session.treemap})}
  end

  def render(assigns) do
    ~L"""
    <div>
      <hr/>
      <b>TREE</b><br/>
      <%= for folder <- @treemap do %>
        <a href='#' phx-click='clk_folder' phx-value='<%= folder.id %>'>
          <%= folder.name %>
        </a><br/>
        <%= for register <- folder.registers do %>
          -> <a href='#' phx-click='clk_feed' phx-value='<%= register.id %>'><%= register.name %></a><br/>
        <% end %>
      <% end %>
      <small>
      <table class='table table-sm' style='margin-top: 20px;'>
        <tr><td>UserId</td><td><td><%= @uistate.user_id %></td></tr>
        <tr><td>Mode</td><td><td><%= @uistate.mode %></td></tr>
        <tr><td>RegId</td><td><td><%= @uistate.reg_id %></td></tr>
        <tr><td>FoldId</td><td><td><%= @uistate.fold_id %></td></tr>
        <tr><td>Folder</td><td><td><%= @uistate.fold_state %></td></tr>
        <tr><td>PostId</td><td><td><%= @uistate.post_id %></td></tr>
        <tr><td>Post</td><td><td><%= @uistate.post_state %></td></tr>
      </table>
      </small>
    </div>
    """
  end

  def handle_event("clk_folder", payload, socket) do
    opts = %{
      reg_id: nil,
      fold_id: Integer.parse(payload) |> elem(0)
    }

    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "TREE_FOLDER", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: new_state, treemap: socket.assigns.treemap})}
  end

  def handle_event("clk_feed", payload, socket) do
    opts = %{
      reg_id: Integer.parse(payload) |> elem(0),
      fold_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "TREE_FEED", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: new_state, treemap: socket.assigns.treemap})}
  end

  def handle_info(_state, socket) do
    {:noreply, assign(socket, %{})}
  end
end
