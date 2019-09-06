defmodule RaggedWeb.Live.News do
  use Phoenix.LiveView
  use Timex

  def mount(_session, socket) do
    {:ok, assign(socket, %{})}
  end

  def render(assigns) do
    ~L"""
    HELLO WORLD
    """
  end
end
