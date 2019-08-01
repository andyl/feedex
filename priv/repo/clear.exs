# Remove all application data
# > mix run priv/repo/clear.exs

alias RaggedData.Ctx.Account.{User, Folder, FeedLog}
alias RaggedData.Ctx.News.{Feed, Post}
alias RaggedData.Repo

Repo.delete_all(Post)
Repo.delete_all(Feed)
Repo.delete_all(FeedLog)
Repo.delete_all(Folder)
Repo.delete_all(User)
