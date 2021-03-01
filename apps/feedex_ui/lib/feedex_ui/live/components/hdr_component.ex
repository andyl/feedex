defmodule FeedexUi.HdrComponent do
  @moduledoc """
  Renders the hdr component.

  Call using:

      <%= live_component(@socket, FeedexUi.HdrComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="bg-gray-300 desktop-only">
      HDR COMPONENT
    </div>
    """
  end
end
