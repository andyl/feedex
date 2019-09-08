defmodule RaggedWeb.News.Hdr do
  use Phoenix.LiveView

  alias Phoenix.HTML

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <%= if @uistate.mode == "view" do %>
    <div class='row'>
    <div class='col-md-6'>
      <%= title(@uistate) %>
    </div>
    <div class='col-md-6 text-right'>
      <%= HTML.raw btns(@uistate) %>
    </div>
    </div>
    <hr/>
    <% end %>
    """
  end

  # ----- view helpers -----
  
  defp title(state) do
    case {state.reg_id, state.fold_id} do
      {nil    , nil} -> "ALL"
      {reg_id, nil}  -> register_name(reg_id)
      {nil, fold_id} -> folder_name(fold_id)
    end
  end

  defp folder_name(folder_id) do
    RaggedData.Ctx.Account.folder_get(folder_id).name
  end

  defp register_name(register_id) do
    RaggedData.Ctx.Account.register_get(register_id).name
  end

  defp btns(state) do
    show_pencil = state.reg_id != nil || state.fold_id != nil
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
    <i class='fa fa-check' style='margin-right: 10px;'></i>
    </a>
    <a href='#'>
    <i class='fa fa-redo' style='margin-right: 10px;'></i>
    </a>
    #{pencil}
    """
  end
  
  # ----- event handlers -----
  
  def handle_event("click-edit", _click, socket) do
    uistate = socket.assigns.uistate
    new_mode = case {uistate.fold_id, uistate.reg_id} do
      {_id, nil} -> "edit_folder"
      {nil, _id} -> "edit_feed"
    end
    new_state = Map.merge(uistate, %{mode: new_mode})
    payload = %{uistate: new_state}
    RaggedWeb.Endpoint.broadcast_from(self(), "uistate", "click_#{new_mode}", payload)
    {:noreply, assign(socket, %{uistate: new_state})}
  end
  
  # ----- pub/sub handlers -----

  def handle_info(%{topic: "uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end
end
