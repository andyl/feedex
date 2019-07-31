defmodule RaggedData.Ctx.News.PostTest do 
  use ExUnit.Case, async: true
  alias RaggedData.Repo
  alias RaggedData.Ctx.News.Post
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
      attr = %{feed_id: 1, body: "asdf", exid: "qwerq"}
      cs = Post.changeset(%Post{}, attr)
      assert cs.valid?
    end
  end

  describe "inserting records" do
    test "adds a record" do
      attr = %{body: "asdf", exid: "asdf"}
      cset = Post.changeset(%Post{}, attr)
      cqry = from(t in "posts", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert Repo.one(cqry) == 1
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:post)
    end

    test "inserting an entity" do
      cqry = from(t in "posts", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert insert(:post)
      assert Repo.one(cqry) == 1
    end

    test "inserting two entities" do
      cqry = from(t in "posts", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert insert(:post)
      assert insert(:post)
      assert Repo.one(cqry) == 2
    end

    test "uses alternate attrs" do
      cqry = from(t in "posts", select: count(t.id))
      altname = "NEWNAME"
      assert Repo.one(cqry) == 0
      assert trak = insert(:post, %{body: altname})
      assert Repo.one(cqry) == 1
      assert trak.body == altname
    end
  end

  describe "deleting records" do
    test "all posts" do
      cqry = from(t in "posts", select: count(t.id))
      assert Repo.one(cqry) == 0
      insert(:post)
      assert Repo.one(cqry) == 1
      Repo.delete_all(Post)
      assert Repo.one(cqry) == 0
    end
  end
end
