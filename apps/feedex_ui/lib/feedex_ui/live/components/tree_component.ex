defmodule FeedexUi.TreeComponent do
  @moduledoc """
  Renders the tree

  Call using:

      <%= live_component(@socket, FeedexUi.TreeComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div>
      TREE COMPONENT
    </div>
    """
  end
end
