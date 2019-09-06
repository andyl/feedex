defmodule RaggedWeb.News.Hdr do
  use Phoenix.LiveView

  alias Phoenix.HTML
  # alias RaggedData.Ctx.News.

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
    case {state.feed_id, state.folder_id} do
      {nil    , nil} -> "ALL"
      {feed_id, nil} -> feed_name(feed_id)
      {nil, fold_id} -> folder_name(fold_id)
    end
  end

  defp folder_name(folder_id) do
    RaggedData.Ctx.Account.folder_get(folder_id).name
  end

  defp feed_name(feed_id) do
    RaggedData.Ctx.News.feed_get(feed_id).name
  end

  defp btns(state) do
    show_pencil = state.feed_id != nil || state.folder_id != nil
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
