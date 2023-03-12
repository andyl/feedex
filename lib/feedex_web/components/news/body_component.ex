defmodule FeedexWeb.BodyComponent do
  @moduledoc """
  Renders the btn component.

  Call using:

      <%= live_component(FeedexUi.BodyComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent

  alias FeedexWeb.{BodyAddFeedComponent, BodyAddFolderComponent}
  alias FeedexWeb.{BodyEditFeedComponent, BodyEditFolderComponent}
  alias FeedexWeb.{BodyViewComponent}

  # def update(session, socket) do
  #   {:ok, socket}
  # end

  def render(assigns) do
    ~H"""
    <div class="px-2 pt-1 bg-white">
      <%= render_body(@counts, @uistate) %>
    </div>
    """
  end

  # ----- view helpers -----

  def render_body(counts, uistate) do
    case uistate.mode do
      "view" -> live_component(BodyViewComponent, opts(counts, uistate, "view"))
      "add_feed" -> live_component(BodyAddFeedComponent, opts(counts, uistate, "afee"))
      "add_folder" -> live_component(BodyAddFolderComponent, opts(counts, uistate, "afol"))
      "edit_feed" -> live_component(BodyEditFeedComponent, opts(counts, uistate, "efee"))
      "edit_folder" -> live_component(BodyEditFolderComponent, opts(counts, uistate, "efol"))
      _ -> live_component(BodyViewComponent, opts(counts, uistate, "view"))
    end
  end

  def opts(counts, uistate, element) do
    num = Enum.random(100_000..999_999)
    [counts: counts, uistate: uistate, id: "#{element}_#{num}"]
  end
end
