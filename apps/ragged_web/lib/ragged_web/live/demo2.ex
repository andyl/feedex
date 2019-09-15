defmodule RaggedWeb.Live.Demo2 do

  use Phoenix.LiveView
  use LiveEdit.Base

  def mount(_session, socket) do
    {:ok, assign(socket, focus: nil)}
  end

  def render(assigns) do
    ~L"""
    <style>
      .editable-click { cursor: pointer;}
    </style>

    <h3 style='margin-top: 10px'>Demo 2</h3>

    <%= live_edit(assigns, "asdf", id: "one",   on_submit: 'saveit') %><br/>
    <%= live_edit(assigns, "qwer", id: "two",   on_submit: 'saveit') %><br/>
    <%= live_edit(assigns, "zxcv", id: "three", on_submit: 'saveit') %><br/>

    <a href='#' phx-click='alt'>ALT</a>
    """
  end

  def handle_event(_tag, _payload, socket) do
    {:noreply, socket}
  end
end
