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
  name: "zzz",
  email: "zzz",
  pwd_hash: User.pwd_hash("zzz"),
  folders: [
    %Folder{
      name: "Elixir",
      registers: [
        %Register{
          name: "Elixir Status",
          feed: %Feed{
            name: "Elixir Status Feed",
            url:  "http://elixirstatus.com/rss"
          }
        },
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
          name: "Elixir Reddit",
          feed: %Feed{
            name: "Elixir Reddit Feed",
            url:  "https://old.reddit.com/r/elixir/.rss"
          }
        }
      ]
    },
    %Folder{
      name: "B_Folder1",
      registers: [
        %Register{
          name: "B_Register1",
          feed: %Feed{
            name: "B_Feed1",
            posts: [
              %Post{
                body: "B_Post1"
              },
              %Post{
                body: "B_Post2"
              }
            ]
          }
        }
      ]
    }
  ]
  }
)
