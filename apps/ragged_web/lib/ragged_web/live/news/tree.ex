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
        <%= for feedlog <- folder.feed_logs do %>
          -> <a href='#' phx-click='clk_feed' phx-value='<%= feedlog.id %>'><%= feedlog.name %></a><br/>
        <% end %>
      <% end %>
    </div>
    """
  end

  def handle_event("clk_folder", payload, socket) do
    opts = %{
      feed_id: nil,
      folder_id: Integer.parse(payload) |> elem(0)
    }

    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "TREE_FOLDER", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: new_state, treemap: socket.assigns.treemap})}
  end

  def handle_event("clk_feed", payload, socket) do
    opts = %{
      feed_id: Integer.parse(payload) |> elem(0),
      folder_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "TREE_FEED", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: new_state, treemap: socket.assigns.treemap})}
  end

  def handle_info(_state, socket) do
    # IO.inspect(state)
    {:noreply, assign(socket, %{})}
  end
end
