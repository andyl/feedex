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
      <div style='margin-bottom: 4px;'>
      <small>
      <%= live_render(@socket, RaggedWeb.TimePstSec) %>
      </small>
      <p></p>
      </div>
      <%= folder_btn(@uistate) %>
      <%= feed_btn(@uistate) %>
      <p></p>
      <%= all_btn(@uistate) %> <%= HTML.raw unread(@uistate.usr_id) %><br/>
    </div>
    """
  end
  
  # ----- view helpers -----

  def folder_btn(uistate) do
    label = "<i class='fa fa-plus fa-fw' style='padding-right: 5px;'></i> Folder<br/>"
    if uistate.mode == "add_folder" do
      label
    else
      "<a phx-click='add_folder' href='#'>#{label}</a>"
    end |> HTML.raw()
  end

  def feed_btn(uistate) do
    label = "<i class='fa fa-plus fa-fw' style='padding-right: 5px;'></i> Feed<br/>"
    if uistate.mode == "add_feed" do
      label
    else
      "<a phx-click='add_feed' href='#'>#{label}</a>"
    end |> HTML.raw()
  end

  def all_btn(uistate) do
    if uistate.mode == "view" && uistate.fld_id == nil && uistate.reg_id == nil do
      "<b>ALL</b>"
    else
      "<a phx-click='view_all' href='#'>ALL</a>"
    end |> HTML.raw()
  end
   
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
    opts = %{ 
      mode: "add_feed", 
      usr_id: socket.assigns.uistate.usr_id,
      reg_id: nil, 
      fld_id: nil, 
      pst_id: nil, 
    }
    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "BTN_ADD_FEED", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: opts})}
  end

  def handle_event("add_folder", _payload, socket) do
    opts = %{ 
      mode: "add_folder", 
      usr_id: socket.assigns.uistate.usr_id,
      reg_id: nil, 
      fld_id: nil, 
      pst_id: nil, 
    }
    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "BTN_ADD_FOLDER", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: opts})}
  end

  def handle_event("view_all", _payload, socket) do
    opts = %{ 
      mode: "view", 
      usr_id: socket.assigns.uistate.usr_id,
      reg_id: nil, 
      fld_id: nil, 
      pst_id: nil, 
    }
    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "BTN_VIEW_ALL", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: opts})}
  end

  def handle_event(_type, _payload, socket) do
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
