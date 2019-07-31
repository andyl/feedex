defmodule RaggedData.Ctx.Account.FeedLogTest do
  use ExUnit.Case, async: true
  alias RaggedData.Repo
  alias RaggedData.Ctx.Account.FeedLog
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
      tmap = %FeedLog{}
      attr = %{name: "asdf"}
      cs = FeedLog.changeset(tmap, attr)
      assert cs.valid?
    end
  end

  describe "inserting records" do
    test "adds a record" do
      tmap = %FeedLog{}
      attr = %{name: "asdf"}
      cset = FeedLog.changeset(tmap, attr)
      cqry = from(t in "feed_logs", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert Repo.one(cqry) == 1
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:feed_log)
    end

    test "inserting an entity" do
      cqry = from(t in "feed_logs", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert insert(:feed_log)
      assert Repo.one(cqry) == 1
    end

    test "inserting two entities" do
      fqry = from(t in "feed_logs", select: count(t.id))
      uqry = from(t in "users", select: count(t.id))
      assert Repo.one(fqry) == 0
      assert insert(:feed_log)
      assert insert(:feed_log)
      assert Repo.one(fqry) == 2
      assert Repo.one(uqry) == 2
    end

    test "uses alternate attrs" do
      cqry = from(t in "feed_logs", select: count(t.id))
      altname = "NEWNAME"
      assert Repo.one(cqry) == 0
      assert trak = insert(:feed_log, %{name: altname})
      assert Repo.one(cqry) == 1
      assert trak.name == altname
    end
  end

  describe "deleting records" do
    test "all feed_logs" do
      cqry = from(t in "feed_logs", select: count(t.id))
      assert Repo.one(cqry) == 0
      insert(:feed_log)
      assert Repo.one(cqry) == 1
      Repo.delete_all(FeedLog)
      assert Repo.one(cqry) == 0
    end
  end

  describe "folder association" do
    test "finds the folder from the feed_log" do
      fusr =
        from(f in "feed_logs",
          join: u in "folders",
          on: [id: f.folder_id],
          select: {f.name, u.name}
        )
      insert(:feed_log)
      result = Repo.all(fusr)
      assert Enum.count(result) == 1
    end

    test "finds the feed_log from the folder" do
      ufold =
        from(u in "folders",
          join: f in "feed_logs",
          on: u.id == f.folder_id,
          select: {f.name, u.name}
        ) 
      insert(:feed_log)
      result = Repo.all(ufold)
      assert Enum.count(result) == 1
    end
  end
end
