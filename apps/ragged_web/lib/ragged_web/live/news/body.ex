defmodule RaggedWeb.News.Body do
  alias RaggedWeb.News.{BodyAddFeed, BodyAddFolder}
  alias RaggedWeb.News.{BodyEditFeed, BodyEditFolder}
  alias RaggedWeb.News.{BodyView}

  use Phoenix.LiveView

  def mount(session, socket) do
    RaggedWeb.Endpoint.subscribe("uistate")
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div>
    <%= render_body(@socket, @uistate) %>
    </div>
    """
  end

  # ----- view helpers -----
  
  def render_body(socket, uistate) do
    session = [session: %{uistate: uistate}]
    IO.inspect "======================================="
    IO.inspect socket
    IO.inspect "---------------------------------------"
    IO.inspect uistate
    IO.inspect "======================================="
    case uistate.mode do
      "view"        -> live_render(socket, BodyView,       session)
      "add_feed"    -> live_render(socket, BodyAddFeed,    session)
      "add_folder"  -> live_render(socket, BodyAddFolder,  session)
      "edit_feed"   -> live_render(socket, BodyEditFeed,   session)
      "edit_folder" -> live_render(socket, BodyEditFolder, session)
      _             -> live_render(socket, BodyView,       session)
    end
  end

  # ----- pub/sub handlers -----

  def handle_info(%{topic: "uistate", payload: new_state}, socket) do
    {:noreply, assign(socket, %{uistate: new_state.uistate})}
  end
end
