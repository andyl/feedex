defmodule FeedexUi.BodyComponent do
  @moduledoc """
  Renders the btn component.

  Call using:

      <%= live_component(@socket, FeedexUi.BodyComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="px-2 pt-1">
      BODY COMPONENT
      <%= FeedexUi.Icons.refresh("h-8 text-blue-400", :raw) %>
      <%= FeedexUi.Icons.pencil_alt("h-8 text-blue-400", :raw) %>
      <%= FeedexUi.Icons.check_circle("h-8 text-blue-400", :raw) %>
    </div>
    """
  end
end
