defmodule RaggedWeb.News.BodyAddFolder do
  alias RaggedData.Ctx.News

  use Phoenix.LiveView

  def mount(session, socket) do
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div>
    BODY ADD FOLDER
    </div>
    """
  end
  
  # ----- pub/sub handlers -----

  def handle_info(_params, socket) do
    {:noreply, socket}
  end
end
