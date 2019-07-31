alias RaggedData.Ctx.Account.User
# alias RaggedData.Ctx.Account.{User, Folder, FeedLog}
# alias RaggedData.Ctx.News.{Feed, Post}

RaggedData.Repo.insert! %User{
  name: "user1",
  email: "asdf@qwer.com"
}

