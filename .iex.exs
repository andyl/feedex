IO.puts("--------------------------- RAGGED DATA ---------------------------")

import_file_if_available("~/.iex.exs")

alias RaggedData.Ctx.Account
alias RaggedData.Ctx.Account.{User, Folder, FeedLog}

alias RaggedData.Ctx.News
alias RaggedData.Ctx.News.{Feed, Post}

alias RaggedData.Cache.UiState

import_if_available(Ecto.Query)

