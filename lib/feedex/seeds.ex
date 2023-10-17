defmodule Feedex.Seeds do
  alias Feedex.Ctx.Account.{User, Folder, Register, ReadLog}
  alias Feedex.Ctx.News.{Feed, Post}
  alias Feedex.Repo

  import Ecto.Query

  def load_if_empty do
    qry = from u in "users", select: u.id
    num = Repo.all(qry) |> length
    if num == 0 do
      require Logger
      Logger.info("No users - loading seeds...")
      load()
    end
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
            # %Register{
            #   name: "Amberbit",
            #   feed: %Feed{url: "https://www.amberbit.com/blog.rss"}
            # }
          ]
        },
        # %Folder{
        #   name: "SeedTech",
        #   registers: [
        #     %Register{
        #       name: "TechMeme",
        #       feed: %Feed{url: "http://www.techmeme.com/feed.xml"}
        #     },
        #     %Register{
        #       name: "TechCrunch",
        #       feed: %Feed{url: "http://feeds.feedburner.com/TechCrunch"}
        #     },
        #     %Register{
        #       name: "MitReview",
        #       feed: %Feed{url: "https://www.technologyreview.com/topnews.rss"}
        #     }
        #   ]
        # },
        # %Folder{
        #   name: "SeedYouTube",
        #   registers: [
        #     %Register{
        #       name: "Empex",
        #       feed: %Feed{url: "https://www.youtube.com/feeds/videos.xml?channel_id=UCIYiFWyuEytDzyju6uXW40Q"}
        #     },
        #     %Register{
        #       name: "ElixirConf",
        #       feed: %Feed{url: "https://www.youtube.com/feeds/videos.xml?channel_id=UC0l2QTnO1P2iph-86HHilMQ"}
        #     },
        #     %Register{
        #       name: "CodeSync",
        #       feed: %Feed{url: "https://www.youtube.com/feeds/videos.xml?channel_id=UC47eUBNO8KBH_V8AfowOWOw"}
        #     }
        #   ]
        # }
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
