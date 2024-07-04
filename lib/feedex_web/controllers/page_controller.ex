defmodule FeedexWeb.PageController do
  use FeedexWeb, :controller

  def home(conn, _params) do
    values = Util.BuildInfo.read()

    IO.inspect(values, label: "TANGOFOR")

    System.cmd("pwd", []) |> IO.inspect(label: "BINGOBOB")

    render(conn, :home, layout: false, attributes: values)
  end
end
