defmodule RaggedWeb.News.Hdr do
  use Phoenix.LiveView

  def mount(_session, socket) do
    {:ok, assign(socket, %{})}
  end

  def render(assigns) do
    ~L"""
    <div>
      HDR
      <%= live_render(@socket, RaggedWeb.Demo2.FormInput) %>
    </div>
    """
  end
end
