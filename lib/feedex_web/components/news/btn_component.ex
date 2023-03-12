defmodule FeedexWeb.BtnComponent do
  @moduledoc """
  Renders the btn component.

  Call using:

      <%= live_component(@socket, FeedexUi.BtnComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent
  import Phoenix.HTML
  import FeedexWeb.BootstrapIconHelpers

  def render(assigns) do
    ~H"""
    <div class="py-1">
      <hr />
      <.fbtn uistate={@uistate} label="Folder" action="add_folder" myself={@myself} />
      <.fbtn uistate={@uistate} label="Feed" action="add_feed" myself={@myself} />
    </div>
    """
  end

  # ----- view helpers -----

  def fbtn(assigns) do
    ~H"""
    <div class="py-1">
      <a class='text-sm' phx-click={@action} phx-target={@myself} href='#'>
        <%= raw plus_circle_svg("up-12 h-5 inline") %> <%= @label %><br/>
      </a>
    </div>
    """
  end

  # ----- event handlers -----

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
    click_handle("add_feed", socket)
  end

  def handle_event("add_folder", _payload, socket) do
    click_handle("add_folder", socket)
  end

  # ----- event helpers -----

  defp click_handle(mode, socket) do
    new_state = %{
      mode: mode,
      usr_id: socket.assigns.uistate.usr_id,
      reg_id: nil,
      fld_id: nil,
      pst_id: nil
    }

    send(self(), {"set_uistate", %{uistate: new_state}})

    {:noreply, assign(socket, %{uistate: new_state})}
  end

end
