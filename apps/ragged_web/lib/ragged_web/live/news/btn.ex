defmodule RaggedWeb.News.Btn do
  use Phoenix.LiveView

  def mount(_session, socket) do
    {:ok, assign(socket, %{})}
  end

  def render(assigns) do
    ~L"""
    <div>
      BTNS<br/>
      <i class="fa fa-plus"   style="padding-right: 5px;"></i> Add Feed<br/>
      <i class="fa fa-plus"   style="padding-right: 5px;"></i> Add Folder<br/>
      <i class="fa fa-expand" style="padding-right: 5px;"></i> View All<br/>
    </div>
    """
  end
end
