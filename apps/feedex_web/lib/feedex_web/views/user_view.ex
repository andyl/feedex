defmodule FeedexWeb.UserView do
  use FeedexWeb, :view
  alias FeedexData.Ctx.Account

  def first_name(%Account.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
