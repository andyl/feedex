defmodule RaggedWeb.News.Tree do
  
  use Phoenix.LiveView

  alias Phoenix.HTML
  alias RaggedData.Repo
  alias RaggedData.Ctx.Account.Register

  import Phoenix.HTML

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    user_id = session.uistate.usr_id
    opts = %{
      uistate: session.uistate, 
      treemap: session.treemap,
      fld_count: RaggedData.Ctx.News.unread_aggregate_count_for(user_id, type: "fld"),
      reg_count: RaggedData.Ctx.News.unread_aggregate_count_for(user_id, type: "reg")
      }
    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    uistate = assigns.uistate
    open_folder = uistate.fld_id || get_fld(uistate.reg_id)
    ~L"""
    <div class='desktop-only'>
      <p></p>
      <%= all_btn(@uistate) %> <%= HTML.raw unread(@uistate.usr_id) %><br/>
      <small>
      <%= for folder <- @treemap do %>
        <p></p>
        <%= fold_link(@uistate, folder) %>
        <%= unread(folder.id, @fld_count) %>
        <%= if open_folder == folder.id do %>
        <%= for register <- folder.registers do %>
          <br/>
          > <%= reg_link(@uistate, register) %> <%= unread(register.id, @reg_count) %>
        <% end %>
        <% end %>
      <% end %>
      </small>
      <p></p>
      <small>
      <%# HTML.raw state_table(@uistate) %>
      </small>
    </div>
    <div class='mobile-only'>
      <%= all_btn(@uistate) %> <%= HTML.raw unread(@uistate.usr_id) %>
      <small>
      <%= for folder <- @treemap do %>
        &emsp;
        &emsp;
        <%= fold_link(@uistate, folder) %>
        <%= unread(folder.id, @fld_count) %>
      <% end %>
      </small>
    </div>
    """
  end

  # ----- view helpers -----

  def all_btn(uistate) do
    if uistate.mode == "view" && uistate.fld_id == nil && uistate.reg_id == nil do
      "<b>ALL</b>"
    else
      "<a phx-click='view_all' href='#'>ALL</a>"
    end |> HTML.raw()
  end
   
  def fold_link(uistate, folder) do
    if uistate.fld_id == folder.id do
      "<b>#{folder.name}</b>"
    else
      """
      <a href='#' phx-click='clk_folder' phx-value='#{folder.id}'>
      #{folder.name}
      </a>
      """
    end |> HTML.raw()
  end

  def reg_link(uistate, register) do
    if uistate.reg_id == register.id do
      "<b>#{register.name}</b>"
    else
      """
      <a href='#' phx-click='clk_feed' phx-value='#{register.id}'>#{register.name}</a> 
      """
    end |> HTML.raw()
  end
  
  def get_fld(regid) do
    case regid do
      nil -> nil
      id when is_number(id) -> Repo.get(Register, id).folder_id
      _ -> nil
    end
  end

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

  def unread(id, unread_count) do
    count = unread_count[id] || 0
    if count == 0 do
      ""
    else
      """
      <span class="badge badge-light" #{style()}>#{count}</span>
      """
    end |> raw()
  end
   
  # ----- event handlers -----

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

  def handle_event("clk_folder", payload, socket) do
    opts = %{
      mode:   "view",
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
      mode:   "view",
      reg_id: Integer.parse(payload) |> elem(0),
      fld_id: nil,
      pst_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "TREE_FEED", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: new_state, treemap: socket.assigns.treemap})}
  end

  # ----- pub/sub handlers -----

  def handle_info(%{topic: "uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end
end
