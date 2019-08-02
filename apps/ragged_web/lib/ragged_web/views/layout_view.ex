defmodule RaggedWeb.LayoutView do
  use RaggedWeb, :view

  def hdr_link(conn, lbl, path) do
    ~e"""
    <li class="nav-item">
      <%= active_link(conn, lbl, to: path, class_active: "nav-link active", class_inactive: "nav-link") %>
    </li>
    """
  end

  def logout_link(conn, user) do
    path = Routes.session_path(conn, :delete, user)
    ~e"""
    <li class="nav-item">
      <%= link "LOGOUT", to: path, method: "delete", class: "nav-link" %>
    </li>
    """
  end

  def ftr_link(conn, lbl, path) do
    ~e"""
    <li class="nav-item">
      <%= active_link(conn, lbl, to: path, class_active: "nav-link disabled", class_inactive: "nav-link") %>
    </li>
    """
  end

  def ftr_lbl_time(conn) do
    ~e"""
    <li class="nav-item">
      <a class="nav-link disabled">
        <%= live_render(conn, RaggedWeb.TimePstMin) %>
      </a>
    </li>
    """
  end
end
