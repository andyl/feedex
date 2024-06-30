defmodule Feedex.Seeds do
  alias Feedex.Ctx.Account.{User, Folder, Register, ReadLog}
  alias Feedex.Ctx.News.{Feed, Post}
  alias Feedex.Repo

  import Ecto.Query

  def load_if_empty do
    require Logger
    Logger.info("------------------------------------------------------")
    Logger.info("----- SEED_LOAD_IF_EMPTY")
    Logger.info("------------------------------------------------------")
    qry = from u in "users", select: u.id
    num = Repo.all(qry) |> length
    if num == 0 do
      Logger.info("----- No users - loading seeds...")
      load()
    else
      Logger.info("----- Users exist - skipping seeds...")
    end
    Logger.info("------------------------------------------------------")
  end

  def load do
    Repo.delete_all(ReadLog)
    Repo.delete_all(Register)
    Repo.delete_all(Folder)
    Repo.delete_all(Post)
    Repo.delete_all(Feed)
    Repo.delete_all(User)

    Repo.insert(%User{
      name: "aaa",
      email: "aaa@aaa.com",
      hashed_password: User.pwd_hash("123456789012"),
      folders: [
        %Folder{
          name: "SeedElixir",
          registers: [
            %Register{
              name: "Plataformatec",
              feed: %Feed{url: "http://blog.plataformatec.com.br/tag/elixir/feed"}
            },
          ]
        },
      ]
    })

    Repo.insert(%User{
      name: "bbb",
      email: "bbb@bbb.com",
      hashed_password: User.pwd_hash("123456789012")
    })

    Repo.insert(%User{
      name: "ccc",
      email: "ccc@ccc.com",
      hashed_password: User.pwd_hash("123456789012")
    })
  end
end
