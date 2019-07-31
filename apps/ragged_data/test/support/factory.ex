defmodule RaggedData.Factory do
  use ExMachina.Ecto, repo: RaggedData.Repo
  alias RaggedData.Ctx.Account.{User, Folder, FeedLog}

  def user_factory do
    %User{
      name: sequence(:name, &"user_#{&1}"),
      email: sequence(:email, &"user_#{&1}@test_domain.com")
    }
  end

  def folder_factory do
    %Folder{
      name: sequence(:name, &"folder_#{&1}"),
      user: insert(:user)
    }
  end

  def feed_log_factory do
    %FeedLog{
      name: sequence(:name, &"feed_log_#{&1}"),
      folder: insert(:folder)
    }
  end

end
