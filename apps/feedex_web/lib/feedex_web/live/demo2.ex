defmodule FeedexWeb.Live.Demo2 do

  use Phoenix.LiveView
  use Phoenix.LiveEditable

  def mount(_session, socket) do
    opts = %{
      test_1: "1 - CLICK TO EDIT",
      test_2: "2 - CLICK TO EDIT", 
      focus: nil
    }
    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    ~L"""
    <h3 style='margin-top: 10px'>Demo 2</h3>

    <p>Some examples from PhoenixLiveEditable</p>

    <%= live_edit(assigns, @test_1, type: "text", id: "test_1",   on_submit: 'update') %><br/>
    <%= live_edit(assigns, @test_2, type: "text", id: "test_2",   on_submit: 'update') %><br/>
    """
  end

  def handle_event("update", %{"editable_text" => new_val}, socket) do
    case socket.assigns.focus do
      nil -> 
        {:noreply, socket}
      focus -> 
        key = focus |> String.to_atom()
        {:noreply, socket |> assign(key, new_val) |> assign(:focus, nil)}
    end
  end
end
