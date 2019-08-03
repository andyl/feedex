defmodule RaggedWeb.Demo2.FormInput do
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

  def handle_event(event, payload, socket) do
    # IO.puts "----------------------------"
    # IO.inspect event
    # IO.puts "----------------------------"
    # IO.inspect payload
    # IO.puts "----------------------------"
    # IO.inspect socket
    # IO.puts "----------------------------"
    RaggedWeb.Endpoint.broadcast_from(self(), "form_text", payload["text"], %{text: payload["text"]})
    {:noreply, assign(socket, %{})}
  end
end
