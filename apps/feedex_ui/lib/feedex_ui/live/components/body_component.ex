defmodule FeedexUi.BodyComponent do
  @moduledoc """
  Renders the btn component.

  Call using:

      <%= live_component(@socket, FeedexUi.BodyComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent

  import FeedexUi.IconHelpers

  alias FeedexUi.{BodyAddFeedComponent, BodyAddFolderComponent}
  alias FeedexUi.{BodyEditFeedComponent, BodyEditFolderComponent}
  alias FeedexUi.{BodyViewComponent}

  def render(assigns) do
    ~L"""
    <div class="px-2 pt-1">
      <%= render_body(@socket, @uistate) %>

      <%= refresh("h-8 text-blue-400", :raw) %>
      <%= pencil_alt("h-8 text-blue-400", :raw) %>
      <%= check_circle("h-8 text-blue-400", :raw) %>
    </div>
    """
  end

  # ----- view helpers -----
  
  def render_body(_socket, uistate) do
    case uistate.mode do
      "view"        -> live_component(socket, BodyViewComponent,       session(uistate, "view"))
      "add_feed"    -> live_component(socket, BodyAddFeedComponent,    session(uistate, "afee"))
      "add_folder"  -> live_component(socket, BodyAddFolderComponent,  session(uistate, "afol"))
      "edit_feed"   -> live_component(socket, BodyEditFeedComponent,   session(uistate, "efee"))
      "edit_folder" -> live_component(socket, BodyEditFolderComponent, session(uistate, "efol"))
      _             -> live_component(socket, BodyViewComponent,       session(uistate, "view"))
    end
  end

  def session(uistate, element) do
    num = Enum.random(100_000..999_999)
    [uistate: uistate, id: "#{element}_#{num}"]
  end

end
