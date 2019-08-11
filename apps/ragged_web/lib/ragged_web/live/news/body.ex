defmodule RaggedWeb.News.Body do
  use Phoenix.LiveView

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div>
      BODY
      <%= live_render(@socket, RaggedWeb.Demo2.FormShow) %>
    </div>
    """
  end

  def handle_info(state, socket) do
    {:noreply, assign(socket, %{})}
  end
end
