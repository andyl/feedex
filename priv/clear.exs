# Remove all application data
# > mix run priv/repo/clear.exs

alias FeedexData.Ctx.Account.{User, Folder, Register}
alias FeedexData.Ctx.News.{Feed, Post}
alias FeedexData.Repo

Repo.delete_all(Post)
Repo.delete_all(Feed)
Repo.delete_all(Register)
Repo.delete_all(Folder)
Repo.delete_all(User)
