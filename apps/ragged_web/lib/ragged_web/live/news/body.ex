defmodule RaggedWeb.News.Body do
  use Phoenix.LiveView

  def mount(_session, socket) do
    {:ok, assign(socket, %{})}
  end

  def render(assigns) do
    ~L"""
    <div>
      BODY
      <%= live_render(@socket, RaggedWeb.Demo2.FormShow) %>
    </div>
    """
  end
end
