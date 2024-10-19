IO.puts("--------------------------- FEEDEX DATA ---------------------------")

import_file_if_available("~/.iex.exs")

alias FeedexData.Ctx.Account
alias FeedexData.Ctx.Account.{User, Folder, Register, ReadLog}

alias FeedexData.Ctx.News
alias FeedexData.Ctx.News.{Feed, Post}

alias FeedexData.Api
alias FeedexData.Api.Subs

alias FeedexUi.Cache.UiState

alias FeedexData.Repo
alias FeedexData.Repo, as: R

import_if_available(Ecto.Query)
