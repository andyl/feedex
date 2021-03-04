defmodule FeedexUi.BodyComponent do
  @moduledoc """
  Renders the btn component.

  Call using:

      <%= live_component(@socket, FeedexUi.BodyComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent
  import FeedexUi.IconHelpers

  def render(assigns) do
    ~L"""
    <div class="px-2 pt-1">
      BODY COMPONENT
      <%= refresh("h-8 text-blue-400", :raw) %>
      <%= pencil_alt("h-8 text-blue-400", :raw) %>
      <%= check_circle("h-8 text-blue-400", :raw) %>
    </div>
    """
  end
end
