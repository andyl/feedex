defmodule FeedexData.DataCaseTest do
  use ExUnit.Case, async: true
  use FeedexData.DataCase

  test "loading data" do
    assert count(User) == 0
    load_test_data()
    assert count(User) == 1
    assert count(Folder) == 2
    assert count(Register) == 4
    assert count(Feed) == 4
  end
end
