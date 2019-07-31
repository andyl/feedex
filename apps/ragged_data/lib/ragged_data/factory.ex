defmodule RaggedData.Factory do
  use ExMachina.Ecto, repo: RaggedData.Repo
  alias RaggedData.Ctx.Account.{User, Folder, FeedLog}
  alias RaggedData.Ctx.News.{Feed, Post}

  def feed_factory do
    %Feed{
      name: sequence(:name, &"feed_#{&1}"),
      url: sequence(:url, &"http://test_dom.com/path_#{&1}")
    }
  end

  def post_factory do
    %Post{
      body: sequence(:body, &"body_#{&1}"),
      exid: sequence(:exid, &"exid_#{&1}"),
    }
  end

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
