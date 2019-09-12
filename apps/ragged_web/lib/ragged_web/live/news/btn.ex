defmodule RaggedWeb.News.Btn do
  use Phoenix.LiveView

  alias Phoenix.HTML

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div style='margin-top: 8px;'>
      <a phx-click="add_folder" href="#">
        <i class="fa fa-plus fa-fw" style="padding-right: 5px;"></i> Folder<br/>
      </a>
      <a phx-click="add_feed" href="#">
        <i class="fa fa-plus fa-fw" style="padding-right: 5px;"></i> Feed<br/>
      </a>
      <a phx-click="view_all" href="#">
        <i class="fa fa-eye fa-fw" style="padding-right: 5px;"></i> All 
      </a> <%= HTML.raw unread(@uistate.usr_id) %><br/>
    </div>
    """
  end
  #
  # ----- view helpers -----
   
  def style do
    "style='vertical-align: top; margin-top: 3px; margin-left: 4px;'"
  end

  def unread(user_id) do
    count = RaggedData.Ctx.News.unread_count_for(user_id)
    if count == 0 do
      ""
    else
      """
      <small><span class="badge badge-light" #{style()}>#{count}</span></small>
      """
    end
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

  def handle_event(type, _payload, socket) do
    IO.inspect "======================================="
    IO.inspect type
    IO.inspect "======================================="
    {:noreply, socket}
  end

  # ----- pub/sub helpers -----

  def handle_info(%{topic: "uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end

  def handle_info(_state, socket) do
    {:noreply, assign(socket, %{})}
  end
end
