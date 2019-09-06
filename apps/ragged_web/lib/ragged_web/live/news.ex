defmodule RaggedWeb.Live.News do
  use Phoenix.LiveView
  use Timex
  alias RaggedWeb.Demo1View

  def mount(_session, socket) do
    {:ok, assign(socket, %{})}
  end

  def render(assigns) do
    ~L"""
    HELLO WORLD
    """
  end
end
