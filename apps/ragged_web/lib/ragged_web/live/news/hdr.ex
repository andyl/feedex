defmodule RaggedWeb.News.Hdr do
  use Phoenix.LiveView

  def mount(session, socket) do
    {:ok, assign(socket, %{uistate: session.uistate})}
  end

  def render(assigns) do
    ~L"""
    <div class='row'>
    <div class='col-md-4'>
      HDR
      <%= live_render(@socket, RaggedWeb.Demo2.FormInput) %>
    </div>
    <div class='col-md-8'>
      <table class='table table-sm'>
        <tr><td>UserId</td><td><td><%= @uistate.user_id %></td></tr>
        <tr><td>Mode</td><td><td><%= @uistate.mode %></td></tr>
        <tr><td>FeedId</td><td><td><%= @uistate.feed_id %></td></tr>
        <tr><td>FolderId</td><td><td><%= @uistate.folder_id %></td></tr>
        <tr><td>FolderState</td><td><td><%= @uistate.folder_state %></td></tr>
        <tr><td>PostId</td><td><td><%= @uistate.post_id %></td></tr>
        <tr><td>PostState</td><td><td><%= @uistate.post_state %></td></tr>
      </table>
    </div>
    </div>
    <hr/>
    """
  end
end
