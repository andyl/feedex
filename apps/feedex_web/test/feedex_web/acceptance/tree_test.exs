defmodule Acceptance.TreeTest do
  use ExUnit.Case, async: false
  use FeedexData.DataCase
  use Hound.Helpers
  use FeedexWeb.HoundCase

  describe "Folder Navigation" do
    setup [:load_test_data, :do_login]

    test "expands and collapses folders" do
      click({:link_text, "Elixir"})
      take_screenshot("/tmp/test1.png")
      assert page_source() =~ "Feed"
      # click({:link_text, "TechNews"})
      # take_screenshot("/tmp/test2.png")
      # refute page_source() =~ "Feed"
    end
  end
end
