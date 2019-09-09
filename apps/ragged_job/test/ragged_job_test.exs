defmodule RaggedJobTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock
  alias RaggedData.Repo
  import RaggedData.Factory
  import Ecto.Query

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  describe "#sync" do
    test "valid run" do
      use_cassette "scan_valid_resp_valid_data" do 
        url_string = "https://www.reddit.com/r/elixir.rss"
        feed = insert(:feed, %{url: url_string})
        cqry = from(p in "posts", select: count(p.id))
        assert Repo.one(cqry) == 0
        result = RaggedJob.sync(feed)
      end
    end
  end
end
