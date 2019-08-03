defmodule RaggedWeb.Demo2.FormShow do
  use Phoenix.LiveView
  use Timex

  def mount(_session, socket) do
    RaggedWeb.Endpoint.subscribe("form_text")
    {:ok, assign(socket, text: "")}
  end

  def render(assigns) do
    ~L"""
    <%= @text %>
    """
  end

  # def handle_event("update", text, socket) do
  #   {:noreply, update(socket, :text, fn _ -> text end)}
  # end

  def handle_info(%{topic: "form_text", payload: state}, socket) do
    # IO.puts "##########################################"
    # IO.inspect state
    # IO.puts "##########################################"
    # IO.inspect socket
    # IO.puts "##########################################"
    IO.puts("HANDLE BROADCAST FOR #{state.text}")
    {:noreply, assign(socket, %{text: state.text})}
  end
end
###
