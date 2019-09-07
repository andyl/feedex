defmodule RaggedWeb.News.BodyView do
  alias RaggedData.Ctx.News

  use Phoenix.LiveView

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div>
    <table class="table table-sm">
    <%= for r <- body_rows(@uistate) do %>
      <tr><td>HELLO</td><td><%= r.id %></td></tr>
    <% end %>
    </table>
    </div>
    """
  end

  # ----- view helpers -----

  def body_rows(uistate) do
    case {uistate.reg_id, uistate.fold_id} do
      {nil, nil   }  -> News.posts_all()
      {reg_id, nil}  -> News.posts_for_register(reg_id)
      {nil, fold_id} -> News.posts_for_folder(fold_id)
    end
  end
  
  # ----- pub/sub handlers -----

  def handle_info(%{topic: "uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end
end
