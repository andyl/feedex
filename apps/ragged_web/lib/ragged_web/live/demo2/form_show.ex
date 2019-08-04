defmodule RaggedWeb.Demo2.FormShow do
  use Phoenix.LiveView
  use Timex

  def mount(_session, socket) do
    RaggedWeb.Endpoint.subscribe("form_text")
    {:ok, assign(socket, text: "")}
  end

  def render(assigns) do
    ~L"""
    Output: <%= @text %>
    """
  end

  def handle_info(%{topic: "form_text", payload: state}, socket) do
    {:noreply, assign(socket, %{text: state.text})}
  end
end
