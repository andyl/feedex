defmodule FeedexJobTest do
  use ExUnit.Case
  use Feedex.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  describe "#sync" do
    # test "valid run" do
    #   use_cassette "scan_valid_resp_valid_data" do
    #     url_string = "https://www.reddit.com/r/elixir.rss"
    #     feed = insert(:feed, %{url: url_string})
    #     assert count(Post) == 0
    #     result = FeedexJob.sync(feed)
    #     assert result
    #   end
    # end
  end
end
