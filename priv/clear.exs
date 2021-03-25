# Remove all application data
# > mix run priv/repo/clear.exs

alias FeedexCore.Ctx.Account.User
alias FeedexCore.Ctx.Account.{Folder, Register}
alias FeedexCore.Ctx.News.{Feed, Post}
alias FeedexCore.Repo

Repo.delete_all(Post)
Repo.delete_all(Feed)
Repo.delete_all(Register)
Repo.delete_all(Folder)
Repo.delete_all(User)
