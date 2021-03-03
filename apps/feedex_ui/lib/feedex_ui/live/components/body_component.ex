defmodule FeedexUi.BodyComponent do
  @moduledoc """
  Renders the btn component.

  Call using:

      <%= live_component(@socket, FeedexUi.BodyComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="bg-white">
      BODY COMPONENT
    </div>
    """
  end
end
