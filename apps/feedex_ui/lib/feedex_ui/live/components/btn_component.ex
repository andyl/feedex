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
    if uistate.mode != "add_folder" do
      "<a phx-click='add_folder' href='#'>#{label}</a>"
    else
      ""
    end |> raw()
  end

  def feed_btn(uistate) do
    label = "#{plus_circle("h-5 inline text-blue-500")} Feed<br/>"
    if uistate.mode != "add_feed" do
      "<a phx-click='add_feed' href='#'>#{label}</a>"
    else
      ""
    end |> raw()
  end

  # ----- callbacks -----
  
  def handle_event("view_all", _payload, socket) do
    opts = %{
      mode: "view",
      usr_id: socket.assigns.uistate.usr_id,
      reg_id: nil,
      fld_id: nil,
      pst_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)

    send(self(), {"set_uistate", %{uistate: new_state}})

    {:noreply, assign(socket, %{uistate: opts})}
  end

  def handle_event("add_feed", _payload, socket) do
    new_state = %{
      mode: "add_feed",
      usr_id: socket.assigns.uistate.usr_id,
      reg_id: nil,
      fld_id: nil,
      pst_id: nil
    }

    send(self(), {"set_uistate", %{uistate: new_state}})

    {:noreply, assign(socket, %{uistate: new_state})}
  end

  def handle_event("add_folder", x, y) do
  end

end
