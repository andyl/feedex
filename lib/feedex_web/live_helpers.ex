defmodule FeedexWeb.LiveHelpers do
  def current_path(socket) do
    IO.inspect(socket, label: "SOCKKK")
    socket.assigns.uri.path
  end
end
