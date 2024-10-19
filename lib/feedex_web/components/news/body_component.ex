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
    assigns = %{counts: counts, uistate: uistate}

    case uistate.mode do
      "view" ->
        ~H"<.live_component module={BodyViewComponent} counts={@counts} uistate={@uistate} id=\"view\" />"

      "add_feed" ->
        ~H"<.live_component module={BodyAddFeedComponent} counts={@counts} uistate={@uistate} id=\"afee\" />"

      "add_folder" ->
        ~H"<.live_component module={BodyAddFolderComponent} counts={@counts} uistate={@uistate} id=\"afol\" />"

      "edit_feed" ->
        ~H"<.live_component module={BodyEditFeedComponent} counts={@counts} uistate={@uistate} id=\"efee\" />"

      "edit_folder" ->
        ~H"<.live_component module={BodyEditFolderComponent} counts={@counts} uistate={@uistate} id=\"efol\" />"

      _ ->
        ~H"<.live_component module={BodyViewComponent} counts={@counts} uistate={@uistate} id=\"view\" />"
    end
  end

  def opts(counts, uistate, element) do
    num = Enum.random(100_000..999_999)
    [counts: counts, uistate: uistate, id: "#{element}_#{num}"]
  end
end
