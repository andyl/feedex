defmodule FeedexWeb.News.Body do
  @moduledoc """
  Body component - renders list of posts.
  """

  alias FeedexWeb.News.{BodyAddFeed, BodyAddFolder}
  alias FeedexWeb.News.{BodyEditFeed, BodyEditFolder}
  alias FeedexWeb.News.{BodyView}

  use Phoenix.LiveView

  def mount(session, socket) do
    # FeedexWeb.Endpoint.subscribe("set_uistate")
    # FeedexWeb.Endpoint.subscribe("tree_mod")
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
    case uistate.mode do
      "view"        -> live_render(socket, BodyViewComponent,       session(uistate, "view"))
      "add_feed"    -> live_render(socket, BodyAddFeedComponent,    session(uistate, "afee"))
      "add_folder"  -> live_render(socket, BodyAddFolderComponent,  session(uistate, "afol"))
      "edit_feed"   -> live_render(socket, BodyEditFeedComponent,   session(uistate, "efee"))
      "edit_folder" -> live_render(socket, BodyEditFolderComponent, session(uistate, "efol"))
      _             -> live_render(socket, BodyViewComponent,       session(uistate, "view"))
    end
  end

  def session(uistate, element) do
    num = Enum.random(100_000..999_999)
    [session: %{uistate: uistate}, id: "#{element}_#{num}"]
  end

  # ----- pub/sub handlers -----

  # def handle_info(%{topic: "set_uistate", payload: new_state}, socket) do
  #   {:noreply, assign(socket, %{uistate: new_state.uistate})}
  # end
  #
  # def handle_info(%{topic: "tree_mod", payload: new_state}, socket) do
  #   {:noreply, assign(socket, %{uistate: new_state.uistate})}
  # end

end
