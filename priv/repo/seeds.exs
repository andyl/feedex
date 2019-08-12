# Add application data
# > mix run priv/repo/seeds.exs

alias RaggedData.Ctx.Account.{User, Folder, FeedLog}
alias RaggedData.Ctx.News.{Feed, Post}
alias RaggedData.Repo

Repo.delete_all(FeedLog)
Repo.delete_all(Folder)
Repo.delete_all(Post)
Repo.delete_all(Feed)
Repo.delete_all(User)

Repo.insert(%User{
  name: "zzz",
  email: "zzz",
  folders: [
    %Folder{
      name: "A_Folder1",
      feed_logs: [
        %FeedLog{
          name: "A_FeedLog1",
          feed: %Feed{
            name: "A_Feed1",
            posts: [
              %Post{
                body: "A_Post1"
              },
              %Post{
                body: "A_Post2"
              }
            ]
          }
        },
        %FeedLog{
          name: "A_FeedLog2",
          feed: %Feed{
            name: "A_Feed2",
            posts: [
              %Post{
                body: "A_Post3"
              },
              %Post{
                body: "A_Post4"
              }
            ]
          }
        }
      ]
    },
    %Folder{
      name: "B_Folder1",
      feed_logs: [
        %FeedLog{
          name: "B_FeedLog1",
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
