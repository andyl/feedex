# Add application data
# > mix run priv/repo/seeds.exs

alias RaggedData.Ctx.Account.{User, Folder, Register}
alias RaggedData.Ctx.News.{Feed, Post}
alias RaggedData.Repo

Repo.delete_all(Register)
Repo.delete_all(Folder)
Repo.delete_all(Post)
Repo.delete_all(Feed)
Repo.delete_all(User)


Repo.insert(%User{
  name: "aaa",
  email: "aaa",
  pwd_hash: User.pwd_hash("zzz"),
  folders: [
    %Folder{
      name: "Elixir",
      registers: [
        %Register{
          name: "Elixir Forum",
          feed: %Feed{
            name: "Elixir Forum Feed",
            url:  "https://elixirforum.com/posts.rss"
          }
        },
        %Register{
          name: "Plataformatec",
          feed: %Feed{
            name: "Plataformatec Feed",
            url:  "http://blog.plataformatec.com.br/tag/elixir/feed"
          }
        },
        %Register{
          name: "Amberbit",
          feed: %Feed{
            name: "Amberbit Feed",
            url:  "https://www.amberbit.com/blog.rss"
          }
        },
        %Register{
          name: "Elixir Reddit",
          feed: %Feed{
            name: "Elixir Reddit Feed",
            url:  "https://old.reddit.com/r/elixir/.rss"
          }
        }
      ]
    },
    %Folder{
      name: "TechNews",
      registers: [
        %Register{
          name: "TechMeme",
          feed: %Feed{
            name: "TechMeme Feed",
            url: "http://www.techmeme.com/feed.xml"
          }
        },
        %Register{
          name: "TechCrunch",
          feed: %Feed{
            name: "TechCrunch Feed",
            url: "http://feeds.feedburner.com/TechCrunch"
          }
        },
        %Register{
          name: "MitReview",
          feed: %Feed{
            name: "MitReview Feed",
            url: "https://www.technologyreview.com/topnews.rss"
          }
        },
      ]
    }
  ]
  }
)

Repo.insert(%User{
  name: "bbb",
  email: "bbb",
  pwd_hash: User.pwd_hash("bbb")
  }
)

Repo.insert(%User{
  name: "ccc",
  email: "ccc",
  pwd_hash: User.pwd_hash("ccc")
  }
)
