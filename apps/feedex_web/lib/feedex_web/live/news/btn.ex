defmodule FeedexWeb.News.Btn do
  use Phoenix.LiveView

  import Phoenix.HTML

  def mount(session, socket) do
    FeedexWeb.Endpoint.subscribe("set_uistate")
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div class='desktop-only' style='margin-top: 8px;'>
      <div style='margin-bottom: 4px;'>
      <small>
      <%= live_render(@socket, FeedexWeb.TimePstSec, id: "clock") %>
      </small>
      <p></p>
      </div>
      <%= folder_btn(@uistate) %>
      <%= feed_btn(@uistate) %>
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
    end |> raw()
  end

  def feed_btn(uistate) do
    label = "<i class='fa fa-plus fa-fw' style='padding-right: 5px;'></i> Feed<br/>"
    if uistate.mode == "add_feed" do
      label
    else
      "<a phx-click='add_feed' href='#'>#{label}</a>"
    end |> raw()
  end

  def style do
    "style='vertical-align: top; margin-top: 3px; margin-left: 4px;'"
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
    FeedexWeb.Endpoint.broadcast_from(self(), "set_uistate", "BTN_ADD_FEED", %{uistate: new_state})
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
    FeedexWeb.Endpoint.broadcast_from(self(), "set_uistate", "BTN_ADD_FOLDER", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: opts})}
  end

  def handle_event(_type, _payload, socket) do
    {:noreply, socket}
  end

  # ----- pub/sub helpers -----

  def handle_info(%{topic: "set_uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end

  def handle_info(_state, socket) do
    {:noreply, assign(socket, %{})}
  end
end
