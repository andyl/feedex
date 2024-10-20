defmodule Feedex.Api.RegFeedTest do
  # , async: true
  use ExUnit.Case
  use Feedex.DataCase

  alias Feedex.Api

  describe "#find_or_create_regfeed" do
    test "with no precursors" do
      clear_all([Feed, Register, Folder])
      fld = insert(:folder)
      assert count(Feed) == 0
      assert count(Register) == 0
      assert count(Folder) == 1
      assert Api.RegFeed.find_or_create_regfeed(fld.id, "bong", "http://bing.com")
      assert count(Feed) == 1
      assert count(Register) == 1
      assert count(Folder) == 1
    end

    test "with existing feed" do
      clear_all([Feed, Register, Folder])
      url = "http://ping.com"
      fld = insert(:folder)
      insert(:feed, url: url)
      assert count(Feed) == 1
      assert count(Register) == 0
      assert count(Folder) == 1
      assert Api.RegFeed.find_or_create_regfeed(fld.id, "bong", url)
      assert count(Feed) == 1
      assert count(Register) == 1
      assert count(Folder) == 1
    end
  end
end
