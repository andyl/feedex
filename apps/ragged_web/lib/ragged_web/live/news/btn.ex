defmodule RaggedWeb.News.Btn do
  use Phoenix.LiveView

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div style='margin-top: 8px;'>
      <a phx-click="add_feed" href="#">
        <i class="fa fa-plus fa-fw" style="padding-right: 5px;"></i> Feed<br/>
      </a>
      <a phx-click="add_folder fa-fw" href="#">
        <i class="fa fa-plus" style="padding-right: 5px;"></i> Folder<br/>
      </a>
      <a phx-click="view_all" href="#">
        <i class="fa fa-eye fa-fw" style="padding-right: 5px;"></i> All<br/>
      </a>
    </div>
    """
  end

  def handle_event("add_feed", _payload, socket) do
    new_state = %{ socket.assigns.uistate | mode: "add_feed" }
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "BTN_ADD_FEED", %{uistate: new_state})
    {:noreply, assign(socket, %{})}
  end

  def handle_event("add_folder", _payload, socket) do
    new_state = %{ socket.assigns.uistate | mode: "add_folder" }
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "BTN_ADD_FOLDER", %{uistate: new_state})
    {:noreply, assign(socket, %{})}
  end

  def handle_event("view_all", _payload, socket) do
    opts = %{ 
      mode: "view", 
      feed_id: nil, 
      folder_id: nil, 
      folder_state: "closed",
      post_id: nil, 
      post_state: "closed"
    }
    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "BTN_VIEW_ALL", %{uistate: new_state})
    {:noreply, assign(socket, %{})}
  end

  def handle_info(_state, socket) do
    {:noreply, assign(socket, %{})}
  end
end
