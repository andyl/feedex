defmodule RaggedData.Factory do
  use ExMachina.Ecto, repo: RaggedData.Repo
  alias RaggedData.Ctx.Account.{User}

  # def tracker_factory do
  #   %Tracker{
  #     name: "asdf",
  #     exid: "qwer",
  #     type: "ZZZ"
  #   }
  # end

  # def issue_factory do
  #   %Issue{
  #     exid: "qwer",
  #     type: "ZZZ" ,
  #     tracker: insert(:tracker)
  #   }
  # end

  def user_factory do
    %User{
      name: "asdf",
      email: "bing@bong.com"
    }
  end
end
