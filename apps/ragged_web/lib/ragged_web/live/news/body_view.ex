defmodule RaggedWeb.News.BodyView do
  alias RaggedData.Ctx.News

  use Phoenix.LiveView

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div>
    BODY VIEW
    </div>
    """
  end
end
