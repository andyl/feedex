defmodule RaggedWeb.News.Tree do
  use Phoenix.LiveView

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    IO.inspect session.treemap
    {:ok, assign(socket, %{uistate: session.uistate, treemap: session.treemap})}
  end

  def render(assigns) do
    ~L"""
    <div>
      <hr/>
      <b>TREE</b><br/>
      <%= for folder <- @treemap do %>
        <%= folder.name %><br/>
        <%= for feedlog <- folder.feed_logs do %>
          -> <%= feedlog.name %><br/>
        <% end %>
      <% end %>
    </div>
    """
  end
  
  def handle_info(state, socket) do
    IO.inspect state
    {:noreply, assign(socket, %{})}
  end
end
