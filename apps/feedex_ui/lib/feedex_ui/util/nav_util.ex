defmodule FeedexUi.NavUtil do
  @moduledoc """
  Conveniences for navigation menus.
  """

  import Phoenix.HTML

  @doc """
  Generates tag for inlined form input errors.
  """
  def link(conn, link_path, label) do
    klas = if conn.request_path == link_path, do: active_klas(), else: normal_klas()
    ~e"""
    <a href="<%= link_path %>" class="<%= klas %>"><%= label %></a>
    """
  end
  
  def active_klas do
    "px-3 py-2 text-sm font-medium text-white bg-gray-900 rounded-md"
  end

  def normal_klas do
    "px-3 py-2 text-sm font-medium text-gray-400 hover:bg-gray-700 hover:text-white rounded-md" 
  end

end

