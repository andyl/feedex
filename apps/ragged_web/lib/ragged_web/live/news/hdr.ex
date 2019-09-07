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
      <%= btns(@uistate) |> HTML.raw %>
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
        "<i class='fa fa-pencil-alt'></i>"
      else
        ""
      end

    """
    <i class='fa fa-check' style='margin-right: 10px;'></i>
    <i class='fa fa-redo' style='margin-right: 10px;'></i>
    #{pencil}
    """
  end
  
  # ----- event handlers -----
  
  
  # ----- pub/sub handlers -----

  def handle_info(%{topic: "uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end
end
