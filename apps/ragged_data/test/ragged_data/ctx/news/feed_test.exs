defmodule RaggedData.Ctx.News.FeedTest do 
  use ExUnit.Case, async: true
  alias RaggedData.Repo
  alias RaggedData.Ctx.News.Feed
  import Ecto.Query, only: [from: 2]
  import RaggedData.Factory

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "greet the world" do
    assert "hello" == "hello"
  end

  describe "changesets" do
    test "accepts valid input" do
      tmap = %Feed{}
      attr = %{url: "asdf"}
      cs = Feed.changeset(tmap, attr)
      assert cs.valid?
    end
  end

  describe "inserting records" do
    test "adds a record" do
      tmap = %Feed{}
      attr = %{url: "asdf"}
      cset = Feed.changeset(tmap, attr)
      cqry = from(t in "feeds", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert Repo.one(cqry) == 1
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:feed)
    end

    test "inserting an entity" do
      cqry = from(t in "feeds", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert insert(:feed)
      assert Repo.one(cqry) == 1
    end

    test "inserting two entities" do
      cqry = from(t in "feeds", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert insert(:feed)
      assert insert(:feed)
      assert Repo.one(cqry) == 2
    end

    test "uses alternate attrs" do
      cqry = from(t in "feeds", select: count(t.id))
      altname = "NEWNAME"
      assert Repo.one(cqry) == 0
      assert trak = insert(:feed, %{url: altname})
      assert Repo.one(cqry) == 1
      assert trak.url == altname
    end
  end

  describe "deleting records" do
    test "all feeds" do
      cqry = from(t in "feeds", select: count(t.id))
      assert Repo.one(cqry) == 0
      insert(:feed)
      assert Repo.one(cqry) == 1
      Repo.delete_all(Feed)
      assert Repo.one(cqry) == 0
    end
  end
end
