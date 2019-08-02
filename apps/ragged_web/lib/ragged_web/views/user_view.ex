defmodule RaggedWeb.UserView do
  use RaggedWeb, :view
  alias RaggedData.Ctx.Account

  def first_name(%Account.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
