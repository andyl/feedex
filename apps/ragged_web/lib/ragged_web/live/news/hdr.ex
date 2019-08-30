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
    case IO.inspect({state.feed_id, state.folder_id}) do
      {nil    , nil} -> "ALL"
      {feed_id, nil} -> feed_title(feed_id)
      {nil, fold_id} -> folder_title(fold_id)
    end
  end

  defp feed_title(_feed_id) do
    "feed title"
  end

  defp folder_title(_folder_id) do
    "folder title"
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
