defmodule FeedexUi.NavUtil do
  @moduledoc """
  Conveniences for navigation menus
  """

  import Phoenix.HTML

  @doc """
  Generates tag for inlined form input errors.
  """
  def link(_conn, link, label) do
    class = "px-3 py-2 text-sm font-medium text-white bg-gray-900 rounded-md"
    ~e"""
    <a href="<%= link %>" class="<%= class %>"><%= label %></a>
    """
  end
end
