IO.puts("--------------------------- RAGGED DATA ---------------------------")

import_file_if_available("~/.iex.exs")

alias RaggedData.Ctx.Account
alias RaggedData.Ctx.Account.{User, Folder, FeedLog}

alias RaggedData.Ctx.TestQuery
import RaggedData.Ctx.TestQuery

alias RaggedData.Ctx.News
alias RaggedData.Ctx.News.{Feed, Post}

alias RaggedWeb.Cache.UiState


alias RaggedData.Repo
alias RaggedData.Repo, as: R

import_if_available(Ecto.Query)

