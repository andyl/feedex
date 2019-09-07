defmodule RaggedWeb.News.BodyAddFeed do
  alias RaggedData.Ctx.News

  use Phoenix.LiveView

  def mount(session, socket) do
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div>
    BODY ADD FEED
    </div>
    """
  end
end
