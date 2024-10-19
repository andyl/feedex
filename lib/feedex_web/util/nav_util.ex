defmodule FeedexWeb.NavUtil do
  @moduledoc """
  Conveniences for navigation menus.
  """

  # import Phoenix.HTML

  use Phoenix.Component

  @doc """
  Generates tag for inlined form input errors.
  """
  def link(conn, link_path, label) do
    klas = if conn.request_path == link_path, do: active_klas(), else: normal_klas()
    assigns = %{link_path: link_path, klas: klas, label: label}
    # ~H"""
    # <a href="<%= @link_path %>" class="<%= @klas %>"><%= @label %></a>
    # """
    ~H"""
    <a href={@link_path} class={@klas}><%= @label %></a>
    """
  end

  def active_klas do
    "nav-link disabled"
  end

  def normal_klas do
    "nav-link active"
  end
end
