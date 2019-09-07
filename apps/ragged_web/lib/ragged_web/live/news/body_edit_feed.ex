defmodule RaggedWeb.News.BodyEditFeed do
  alias RaggedData.Ctx.News

  use Phoenix.LiveView

  def mount(session, socket) do
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div>
    BODY EDIT FEED
    </div>
    """
  end
end
