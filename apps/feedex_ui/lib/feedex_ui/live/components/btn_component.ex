defmodule FeedexUi.BtnComponent do
  @moduledoc """
  Renders the btn component.

  Call using:

      <%= live_component(@socket, FeedexUi.BtnComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent
  import Phoenix.HTML
  import FeedexUi.IconHelpers

  def render(assigns) do
    ~L"""
    <div class="py-1 desktop-only">
      <hr/> 
      <%= folder_btn(@uistate) %>
      <%= feed_btn(@uistate) %>
    </div>
    """
  end
  
  # ----- view helpers -----

  def folder_btn(uistate) do
    label = "#{plus_circle("h-5 inline text-blue-500")} Folder<br/>"
    if uistate.mode == "add_folder" do
      label
    else
      "<a phx-click='add_folder' href='#'>#{label}</a>"
    end |> raw()
  end

  def feed_btn(uistate) do
    label = "#{plus_circle("h-5 inline text-blue-500")} Feed<br/>"
    if uistate.mode == "add_feed" do
      label
    else
      "<a phx-click='add_feed' href='#'>#{label}</a>"
    end |> raw()
  end

end
