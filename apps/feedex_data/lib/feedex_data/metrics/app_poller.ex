defmodule FeedexData.Metrics.AppPoller do

  alias FeedexData.Ctx.News.Post
  alias FeedexData.Ctx.Account
  alias FeedexData.Ctx.News

  alias FeedexData.Repo

  import Ecto.Query

  alias FeedexData.Influx

  def post_counts do
    # user = Account.user_get_by_email("aaa")
    # all_pst_count = from(pst in Post, select: count(pst.id)) |> Repo.one()
    # unr_pst_count = News.unread_count_for(user.id)
    # {:ok, host} = :inet.gethostname()
    #
    # m1 = "post_count"
    # f1 = %{total: all_pst_count, unread: unr_pst_count}
    #
    # Influx.write_point(m1, f1, %{host: host})
    IO.puts "Metrics - POST COUNTS"
  end
end
