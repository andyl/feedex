defmodule RaggedWeb.News.Tree do
  
  use Phoenix.LiveView

  alias Phoenix.HTML

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    {:ok, assign(socket, %{uistate: session.uistate, treemap: session.treemap})}
  end

  def render(assigns) do
    ~L"""
    <div>
      <small>
      <%= for folder <- @treemap do %>
        <p></p>
        <a href='#' phx-click='clk_folder' phx-value='<%= folder.id %>'>
          <%= folder.name %>
        </a> <%= HTML.raw unread(@uistate.usr_id, fld_id: folder.id) %>
        <%= for register <- folder.registers do %>
          <br/>
          > <a href='#' phx-click='clk_feed' phx-value='<%= register.id %>'><%= register.name %></a> <%= HTML.raw unread(@uistate.usr_id, reg_id: register.id) %>
        <% end %>
      <% end %>
      </small>
      <p></p>
      <small>
      <%# HTML.raw state_table(@uistate) %>
      <p></p>
      <%= live_render(@socket, RaggedWeb.TimePstSec) %>
      </small>
    </div>
    """
  end

  # ----- view helpers -----
  
  def state_table(uistate) do
    """
      <table class='table table-sm'>
        <tr><td>Mode</td> <td>#{ uistate.mode   }</td></tr>
        <tr><td>UsrId</td><td>#{ uistate.usr_id }</td></tr>
        <tr><td>FldId</td><td>#{ uistate.fld_id }</td></tr>
        <tr><td>RegId</td><td>#{ uistate.reg_id }</td></tr>
        <tr><td>PstId</td><td>#{ uistate.pst_id }</td></tr>
      </table>
    """
  end

   
  def style do
    "style='vertical-align: top; margin-top: 5px; margin-left: 2px;'"
  end

  def unread(user_id, fld_id: folder_id) do
    count = RaggedData.Ctx.News.unread_count_for(user_id, fld_id: folder_id)
    if count == 0 do
      ""
    else
      """
      <span class="badge badge-light" #{style()}>#{count}</span>
      """
    end
  end
   
  def unread(user_id, reg_id: register_id) do
    count = RaggedData.Ctx.News.unread_count_for(user_id, reg_id: register_id)
    if count == 0 do
      ""
    else
      """
      <span class="badge badge-light" #{style()}>#{count}</span>
      """
    end
  end
   
  # ----- event helpers -----

  def handle_event("clk_folder", payload, socket) do
    opts = %{
      fld_id: Integer.parse(payload) |> elem(0),
      reg_id: nil,
      pst_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "TREE_FOLDER", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: new_state, treemap: socket.assigns.treemap})}
  end

  def handle_event("clk_feed", payload, socket) do
    opts = %{
      reg_id: Integer.parse(payload) |> elem(0),
      fld_id: nil,
      pst_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "TREE_FEED", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: new_state, treemap: socket.assigns.treemap})}
  end

  # ----- pub/sub helpers -----

  def handle_info(%{topic: "uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end
end
