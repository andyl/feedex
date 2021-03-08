defmodule FeedexUi.BodyAddFeedComponent do
  @moduledoc """
  Renders the body view component.

  Call using:

      <%= live_component(@socket, FeedexUi.BodyComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent
  # import FeedexUi.IconHelpers

  def render(assigns) do
    ~L"""
    <div>
      HELLO BODY ADD FEED
    </div>
    """
  end

end
