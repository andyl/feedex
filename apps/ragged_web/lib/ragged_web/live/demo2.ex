defmodule RaggedWeb.Live.Demo2 do

  import LiveEdit.Base
  use Phoenix.LiveView

  def mount(_session, socket) do
    # {:ok, assign(socket, count: 0, valid_url: false, status: "", update_str: "", date: ldate())}
    {:ok, assign(socket, focus: nil)}
  end

  def render(assigns) do
    ~L"""
    <style>
      .editable-click { cursor: pointer;}
    </style>

    <h3 style='margin-top: 10px'>Demo 2</h3>

    <%= live_edit("asdf", id: "one",   focus: @focus) %><br/>
    <%= live_edit("qwer", id: "two",   focus: @focus) %><br/>
    <%= live_edit("zxcv", id: "three", focus: @focus) %><br/>
    """
  end

end
