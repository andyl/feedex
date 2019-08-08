defmodule RaggedWeb.News.Tree do
  use Phoenix.LiveView

  def mount(_session, socket) do
    {:ok, assign(socket, %{})}
  end

  def render(assigns) do
    ~L"""
    <div>
      TREE
    </div>
    """
  end
end
