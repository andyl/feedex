defmodule RaggedWeb.News.Tree do
  use Phoenix.LiveView

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div>
      TREE
    </div>
    """
  end
  
  def handle_info(state, socket) do
    {:noreply, assign(socket, %{})}
  end
end
