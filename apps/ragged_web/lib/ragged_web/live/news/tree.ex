defmodule RaggedWeb.News.Tree do
  
  use Phoenix.LiveView

  alias Phoenix.HTML
  alias RaggedData.Repo
  alias RaggedData.Ctx.Account.Register

  import Phoenix.HTML

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("set_uistate")
    RaggedWeb.Endpoint.subscribe("read_one")
    RaggedWeb.Endpoint.subscribe("read_all")
    RaggedWeb.Endpoint.subscribe("tree_mod")

    opts = %{
      uistate: session.uistate, 
      treemap: RaggedData.Ctx.Account.cleantree(session.uistate.usr_id),
      counts:  gen_counts(session.uistate.usr_id)
      }

    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    uistate = assigns.uistate
    open_folder = uistate.fld_id || get_fld(uistate.reg_id)
    ~L"""
    <div class='desktop-only'>
      <p></p>
      <%= all_btn(@uistate) %> <%= unread(@counts.all) %><br/>
      <small>
      <%= for folder <- @treemap do %>
        <p></p>
        <%= fold_link(@uistate, folder) %>
        <%= unread(folder.id, @counts.fld) %>
        <%= if open_folder == folder.id do %>
        <%= for register <- folder.registers do %>
          <br/>
          > <%= reg_link(@uistate, register) %> <%= unread(register.id, @counts.reg) %>
        <% end %>
        <% end %>
      <% end %>
      </small>
      <p></p>
      <small>
      <%= HTML.raw state_table(@uistate) %>
      </small>
    </div>
    <div class='mobile-only'>
      <%= all_btn(@uistate) %> <%= unread(@counts.all) %>
      <small>
      <%= for folder <- @treemap do %>
        &emsp;
        &emsp;
        <%= fold_link(@uistate, folder) %>
        <%= unread(folder.id, @counts.fld) %>
      <% end %>
      </small>
    </div>
    """
  end

  # ----- view helpers -----
 
  def gen_counts(user_id) do
    %{
      all: RaggedData.Ctx.News.unread_count_for(user_id),
      fld: RaggedData.Ctx.News.unread_aggregate_count_for(user_id, type: "fld"),
      reg: RaggedData.Ctx.News.unread_aggregate_count_for(user_id, type: "reg")
    }
  end

  def unread(count) do
    if count == 0 do
      ""
    else
      """
      <small><span class="badge badge-light" #{style()}>#{count}</span></small>
      """
    end |> raw()
  end

  def unread(id, unread_count) do
    unread(unread_count[id] || 0)
  end

  # -----

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
      <a href='#' phx-click='clk_folder' phx-value-fldid='#{folder.id}'>
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
      <a href='#' phx-click='clk_feed' phx-value-regid='#{register.id}'>#{register.name}</a> 
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
    RaggedWeb.Endpoint.broadcast_from(self(), "set_uistate", "BTN_VIEW_ALL", %{uistate: new_state})
    {:noreply, assign(socket, %{uistate: opts})}
  end

  def handle_event("clk_folder", %{"fldid" => fldid}, socket) do
    opts = %{
      mode:   "view",
      fld_id: Integer.parse(fldid) |> elem(0),
      reg_id: nil,
      pst_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "set_uistate", "TREE_FOLDER", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: new_state, treemap: socket.assigns.treemap})}
  end

  def handle_event("clk_feed", %{"regid" => regid}, socket) do
    opts = %{
      mode:   "view",
      reg_id: Integer.parse(regid) |> elem(0),
      fld_id: nil,
      pst_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)
    RaggedWeb.Endpoint.broadcast_from(self(), "set_uistate", "TREE_FEED", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: new_state, treemap: socket.assigns.treemap})}
  end

  # ----- pub/sub handlers -----

  def handle_info(%{topic: "set_uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end

  def handle_info(%{topic: "tree_mod", payload: new_state}, socket) do
    usrid = socket.assigns.uistate.usr_id
    newcounts = usrid |> gen_counts() 
    newtree   = usrid |> RaggedData.Ctx.Account.cleantree()
    {:noreply, assign(socket, %{counts: newcounts, treemap: newtree, uistate: new_state.uistate})}
  end

  def handle_info(%{topic: "read_one"}, socket) do
    newcounts = socket.assigns.uistate.usr_id |> gen_counts() 
    {:noreply, assign(socket, %{counts: newcounts})}
  end

  def handle_info(%{topic: "read_all"}, socket) do
    newcounts = socket.assigns.uistate.usr_id |> gen_counts() 
    {:noreply, assign(socket, %{counts: newcounts})}
  end
end
