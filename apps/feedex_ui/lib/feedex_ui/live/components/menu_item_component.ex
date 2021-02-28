defmodule FeedexUi.MenuItemComponent do
  @moduledoc """
  Renders a nav-bar menu.

  To call from the parent template:
  
      <%= live_component(@socket, FeedexUi.MenuItemComponent, current_path: @current_path, link: "/asdf", label: "My Text" %>

  """

  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <%= link_text(@current_path, @link, @label) %>
    """
  end

  defp link_text(_current_path, link, label) do
    """
    <a href="#{link}">#{label}</a>
    """
  end

end
