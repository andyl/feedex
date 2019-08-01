defmodule RaggedWeb.LayoutView do
  use RaggedWeb, :view

  def hdr_link(conn, lbl, path) do
    ~e"""
    <li class="nav-item">
      <%= active_link(conn, lbl, to: path, class_active: "nav-link active", class_inactive: "nav-link") %>
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
        <%= live_render(conn, RaggedWeb.TimeLcl) %>
      </a>
    </li>
    """
  end
end
