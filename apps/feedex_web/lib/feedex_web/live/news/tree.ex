defmodule FeedexWeb.News.Tree do
  use Phoenix.LiveView

  alias Phoenix.HTML
  alias FeedexData.Repo
  alias FeedexData.Ctx.Account.Register

  import Phoenix.HTML

  def mount(session, socket) do
    FeedexWeb.Endpoint.subscribe("set_uistate")
    FeedexWeb.Endpoint.subscribe("read_one")
    FeedexWeb.Endpoint.subscribe("read_all")
    FeedexWeb.Endpoint.subscribe("tree_mod")

    opts = %{
      uistate: session.uistate,
      treemap: FeedexData.Ctx.Account.cleantree(session.uistate.usr_id),
      counts: gen_counts(session.uistate.usr_id)
    }

    {:ok, assign(socket, opts)}
  end

  def render(assigns) do
    uistate = assigns.uistate
    open_folder = uistate.fld_id || get_fld(uistate.reg_id)

    ~L"""
    <div style='margin-top: 8px;' class='desktop-only'>
      <div class='desktop-only' style='margin-bottom: 4px;'>
      <small>
      <%= live_render(@socket, FeedexWeb.TimePstSec, id: "clock") %>
      </small>
      <p></p>
      </div>
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
      <%# HTML.raw state_table(@uistate) %>
      </small>
    </div>
    <div class='mobile-only'>
      <%= all_btn(@uistate) %> <%= all_unread(@uistate, @counts.all) %>
      <small>
      <%= for folder <- @treemap do %>
        &emsp;
        &emsp;
        <%= fold_link(@uistate, folder) %>
        <%= fold_unread(@uistate, folder.id, @counts.fld[folder.id]) %>
      <% end %>
      </small>
    </div>
    """
  end

  # ----- view helpers -----

  def gen_counts(user_id) do
    %{
      all: FeedexData.Ctx.News.unread_count_for(user_id),
      fld: FeedexData.Ctx.News.unread_aggregate_count_for(user_id, type: "fld"),
      reg: FeedexData.Ctx.News.unread_aggregate_count_for(user_id, type: "reg")
    }
  end

  def unread(0), do: ""

  def unread(count) do
    """
    <small><span class="badge badge-light" #{style()}>#{count}</span></small>
    """
    |> raw()
  end

  def unread(id, unread_count) do
    unread(unread_count[id] || 0)
  end

  # ---

  def check_link(false), do: ""

  def check_link(_) do
    """
      <span style="margin-right: 10px">
      <a href='#'>
      <i class='fa fa-check' phx-click='mark-read'></i>
      </a>  
      </span>
    """
  end

  def all_unread(_uistate, 0), do: ""
  def all_unread(_uistate, nil), do: ""

  def all_unread(uistate, count) do
    """
    <small><span class="badge badge-light" #{style()}>#{count}</span></small>
    #{check_link(uistate.fld_id == nil && uistate.reg_id == nil)}
    """
    |> raw()
  end

  def fold_unread(_uistate, _id, 0), do: ""
  def fold_unread(_uistate, _id, nil), do: ""

  def fold_unread(uistate, id, count) do
    """
    <small><span class="badge badge-light" #{style()}>#{count}</span></small>
    #{check_link(uistate.fld_id == id)}
    """
    |> raw()
  end

  # -----

  def all_btn(uistate) do
    if uistate.mode == "view" && uistate.fld_id == nil && uistate.reg_id == nil do
      "<b>ALL</b>"
    else
      "<a phx-click='view_all' href='#'>ALL</a>"
    end
    |> HTML.raw()
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
    end
    |> HTML.raw()
  end

  def reg_link(uistate, register) do
    if uistate.reg_id == register.id do
      "<b>#{register.name}</b>"
    else
      """
      <a href='#' phx-click='clk_feed' phx-value-regid='#{register.id}'>#{register.name}</a> 
      """
    end
    |> HTML.raw()
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
        <tr><td>Mode</td> <td>#{uistate.mode}</td></tr>
        <tr><td>UsrId</td><td>#{uistate.usr_id}</td></tr>
        <tr><td>FldId</td><td>#{uistate.fld_id}</td></tr>
        <tr><td>RegId</td><td>#{uistate.reg_id}</td></tr>
        <tr><td>PstId</td><td>#{uistate.pst_id}</td></tr>
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
      pst_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)

    FeedexWeb.Endpoint.broadcast_from(self(), "set_uistate", "BTN_VIEW_ALL", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: opts})}
  end

  def handle_event("clk_folder", %{"fldid" => fldid}, socket) do
    opts = %{
      mode: "view",
      fld_id: Integer.parse(fldid) |> elem(0),
      reg_id: nil,
      pst_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)
    FeedexWeb.Endpoint.broadcast_from(self(), "set_uistate", "TREE_FOLDER", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: new_state, treemap: socket.assigns.treemap})}
  end

  def handle_event("clk_feed", %{"regid" => regid}, socket) do
    opts = %{
      mode: "view",
      reg_id: Integer.parse(regid) |> elem(0),
      fld_id: nil,
      pst_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)
    FeedexWeb.Endpoint.broadcast_from(self(), "set_uistate", "TREE_FEED", %{uistate: new_state})

    {:noreply, assign(socket, %{uistate: new_state, treemap: socket.assigns.treemap})}
  end

  def handle_event("mark-read", _click, socket) do
    FeedexWeb.News.Hdr.mark_all_read(socket.assigns.uistate)

    FeedexWeb.Endpoint.broadcast_from(self(), "read_all", "mark-read", %{})

    treemap = FeedexData.Ctx.Account.cleantree(socket.assigns.uistate.usr_id)
    counts = gen_counts(socket.assigns.uistate.usr_id)

    {:noreply, assign(socket, %{treemap: treemap, counts: counts})}
  end

  # ----- pub/sub handlers -----

  def handle_info(%{topic: "set_uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end

  def handle_info(%{topic: "tree_mod", payload: new_state}, socket) do
    usrid = socket.assigns.uistate.usr_id
    newcounts = usrid |> gen_counts()
    newtree = usrid |> FeedexData.Ctx.Account.cleantree()
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
