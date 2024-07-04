defmodule FeedexWeb.PageController do
  use FeedexWeb, :controller

  def home(conn, _params) do
    {:ok, values} = Util.BuildInfo.read()

    render(conn, :home, layout: false, attributes: values)
  end
end
