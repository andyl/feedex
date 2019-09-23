defmodule RaggedData.Metrics.AppPoller do

  alias RaggedData.Ctx.News.Post
  alias RaggedData.Ctx.Account
  alias RaggedData.Ctx.News

  alias RaggedData.Repo

  import Ecto.Query

  alias RaggedData.Influx

  def post_counts do
    user = Account.user_get_by_email("aaa")
    all_pst_count = from(pst in Post, select: count(pst.id)) |> Repo.one()
    unr_pst_count = News.unread_count_for(user.id)
    {:ok, host} = :inet.gethostname()

    m1 = "post_count"
    f1 = %{total: all_pst_count, unread: unr_pst_count}

    Influx.write_point(m1, f1, %{host: host})
  end
end
