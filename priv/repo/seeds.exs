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
      name: "A_Folder1",
      registers: [
        %Register{
          name: "A_Register1",
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
        %Register{
          name: "A_Register2",
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
