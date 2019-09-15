defmodule RaggedWeb.Demo3.FormInput do
  use Phoenix.LiveView
  use Timex

  def mount(_session, socket) do
    {:ok, assign(socket, %{})}
  end

  def render(assigns) do
    ~L"""
    <form phx-change="update_text">
      <input type="text" name="text" placeholder="String..." />
      </input> 
    </form>
    """
  end

  def handle_event("update_text", payload, socket) do
    RaggedWeb.Endpoint.broadcast_from(self(), "form_text", payload["text"], %{text: payload["text"]})
    {:noreply, assign(socket, %{})}
  end
end
