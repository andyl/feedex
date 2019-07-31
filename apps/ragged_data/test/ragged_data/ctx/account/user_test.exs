defmodule RaggedData.Ctx.Account.UserTest do 
  use ExUnit.Case, async: true
  alias RaggedData.Repo
  alias RaggedData.Ctx.Account.User
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
      tmap = %User{}
      attr = %{name: "asdf", email: "asdf@qwer.com"}
      cs = User.changeset(tmap, attr)
      assert cs.valid?
    end
  end

  describe "inserting records" do
    test "adds a record" do
      tmap = %User{}
      attr = %{name: "asdf"}
      cset = User.changeset(tmap, attr)
      cqry = from(t in "users", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert Repo.one(cqry) == 1
    end

    test "handling maps" do 
      lmap = %{a: 1, b: 2}
      tmap = %User{}
      attr = %{name: "asdf", jfields: lmap}
      cset = User.changeset(tmap, attr)
      cqry = from(t in "users", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert {:ok, trak} = Repo.insert(cset)
      assert Repo.one(cqry) == 1
      assert trak.jfields == lmap
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:user)
    end

    test "inserting an entity" do
      cqry = from(t in "users", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert insert(:user)
      assert Repo.one(cqry) == 1
    end

    test "inserting two entities" do
      cqry = from(t in "users", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert insert(:user)
      assert insert(:user)
      assert Repo.one(cqry) == 2
    end

    test "uses alternate attrs" do
      cqry = from(t in "users", select: count(t.id))
      altname = "NEWNAME"
      assert Repo.one(cqry) == 0
      assert trak = insert(:user, %{name: altname})
      assert Repo.one(cqry) == 1
      assert trak.name == altname
    end
  end

  describe "deleting records" do
    test "all users" do
      cqry = from(t in "users", select: count(t.id))
      assert Repo.one(cqry) == 0
      insert(:user)
      assert Repo.one(cqry) == 1
      Repo.delete_all(User)
      assert Repo.one(cqry) == 0
    end
  end
end
