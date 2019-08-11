defmodule RaggedWeb.News.Body do
  use Phoenix.LiveView

  def mount(session, socket) do
    # IO.puts "*****************************************"
    # IO.inspect session.uistate
    # IO.puts "*****************************************"
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    # IO.puts "#########################################"
    # IO.inspect assigns
    # IO.puts "#########################################"
    ~L"""
    <div>
      BODY
      <%= live_render(@socket, RaggedWeb.Demo2.FormShow) %>
    </div>
    """
  end
end
