defmodule FeedexWeb.News.Hdr do
  use Phoenix.LiveView

  alias Phoenix.HTML
  alias FeedexData.Ctx.{Account, News}

  def mount(session, socket) do
    FeedexWeb.Endpoint.subscribe("set_uistate")
    FeedexWeb.Endpoint.subscribe("tree_mod")
    FeedexWeb.Endpoint.subscribe("read_one")
    count = if Application.fetch_env(:feedex_web, :env) == {:ok, :test} do
      0
    else
      News.unread_count(session.uistate)
    end
    {:ok, assign(socket, %{unread: count, uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <%= if @uistate.mode == "view" do %>
    <div class='desktop-only'>
    <div class='row' style="background-color: lightgray; padding-top: 4px; padding-bottom: 4px; margin-bottom: 10px;">
    <div class='col-md-6'>
      <%= title(@uistate, @unread) %>
    </div>
    <div class='col-md-6 text-right'>
      <%= HTML.raw btns(@uistate) %>
    </div>
    </div>
    </div>
    <% end %>
    """
  end

  # ----- view helpers -----
  
  defp title(state, unread) do
    case {state.reg_id, state.fld_id} do
      {nil    , nil} -> all_name(unread)
      {reg_id, nil}  -> register_name(reg_id, unread)
      {nil, fld_id}  -> folder_name(fld_id, unread)
    end |> HTML.raw()
  end

  def mark_all_read(state) do
    case {state.fld_id, state.reg_id} do
      {nil   , nil} -> Account.mark_all_for(state.usr_id)
      {fld_id, nil} -> Account.mark_all_for(state.usr_id, fld_id: fld_id)
      {nil, reg_id} -> Account.mark_all_for(state.usr_id, reg_id: reg_id)
    end
  end

  def sync_all(state) do
    case {state.fld_id, state.reg_id} do
      {nil   , nil} -> FeedexJob.sync_for(state.usr_id)
      {fld_id, nil} -> FeedexJob.sync_for(state.usr_id, fld_id: fld_id)
      {nil, reg_id} -> FeedexJob.sync_for(state.usr_id, reg_id: reg_id)
    end
  end

  defp checklink(unread) do
    style = "style='vertical-align: top; margin-top: 4px; margin-right: 5px; margin-left: 5px;'"
    case unread do
      0 -> ""
      _ -> 
      """
      <small><span class="badge badge-light" #{style}>#{unread}</span></small>
      <span style="margin-right: 10px">
       <a href='#'>
      <i class='fa fa-check' phx-click='mark-read'></i>
      </a>  
      </span>
      """
    end 
  end

  defp all_name(count) do
    "ALL " <> checklink(count)
  end

  defp folder_name(folder_id, unread) do
    FeedexData.Ctx.Account.folder_get(folder_id).name <> checklink(unread)
  end

  defp register_name(register_id, unread) do
    reg = FeedexData.Ctx.Account.register_get(register_id)
    fld = FeedexData.Ctx.Account.folder_get(reg.folder_id)
    flnk = "<a href='#' phx-click='folder-clk' phx-value-fldid='#{fld.id}'>#{fld.name}</a> "
    flnk <> "> " <> FeedexData.Ctx.Account.register_get(register_id).name <> checklink(unread)
  end

  defp btns(state) do
    show_pencil = state.reg_id != nil || state.fld_id != nil
    pencil = 
      if show_pencil do
        """
        <a href='#' phx-click='click-edit'>
        <i class='fa fa-pencil-alt'></i>
        </a>
        """
      else
        ""
      end

    """
    <a href='#'>
    <i class='fa fa-redo' phx-click='feed-sync' style='margin-right: 10px;'></i>
    </a>
    #{pencil}
    """
  end
  
  # ----- event handlers -----
  
  def handle_event("click-edit", _click, socket) do
    uistate = socket.assigns.uistate
    new_mode = case {uistate.fld_id, uistate.reg_id} do
      {_id, nil} -> "edit_folder"
      {nil, _id} -> "edit_feed"
    end
    new_state = Map.merge(uistate, %{mode: new_mode})
    payload = %{uistate: new_state}
    FeedexWeb.Endpoint.broadcast_from(self(), "set_uistate", "click_#{new_mode}", payload)
    {:noreply, assign(socket, %{uistate: new_state})}
  end

  def handle_event("mark-read", _click, socket) do
    mark_all_read(socket.assigns.uistate)

    count = News.unread_count(socket.assigns.uistate)

    FeedexWeb.Endpoint.broadcast_from(self(), "read_all", "mark-read", %{})
    {:noreply, assign(socket, %{unread: count})}
  end

  def handle_event("folder-clk", %{"fldid" => fldid}, socket) do

    opts = %{
      fld_id: Integer.parse(fldid) |> elem(0),
      reg_id: nil,
      pst_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)

    count = News.unread_count(new_state)

    FeedexWeb.Endpoint.broadcast_from(self(), "set_uistate", "HDR", %{uistate: new_state})

    {:noreply, assign(socket, %{unread: count, uistate: new_state})}
  end

  def handle_event("feed-sync", _click, socket) do
    sync_all(socket.assigns.uistate)
    payload = %{uistate: socket.assigns.uistate}
    FeedexWeb.Endpoint.broadcast_from(self(), "set_uistate", "sync-all", payload)
    {:noreply, socket}
  end
  
  # ----- pub/sub handlers -----

  def handle_info(%{topic: "set_uistate", payload: new_state}, socket) do
    count = News.unread_count(new_state.uistate)
    {:noreply, assign(socket, %{unread: count, uistate: new_state.uistate})}
  end

  def handle_info(%{topic: "read_one"}, socket) do
    count = News.unread_count(socket.assigns.uistate)
    {:noreply, assign(socket, %{unread: count})}
  end


  def handle_info(%{topic: "tree_mod", payload: new_state}, socket) do
    count = News.unread_count(new_state.uistate)
    {:noreply, assign(socket, %{unread: count, uistate: new_state.uistate})}
  end
end
