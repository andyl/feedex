defmodule RaggedData.Ctx.Account.FolderTest do
  use ExUnit.Case, async: true
  alias RaggedData.Repo
  alias RaggedData.Ctx.Account.Folder
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
      tmap = %Folder{}
      attr = %{name: "asdf", user_id: 1}
      cs = Folder.changeset(tmap, attr)
      assert cs.valid?
    end
  end

  describe "inserting records" do
    test "adds a record" do
      tmap = %Folder{}
      attr = %{name: "asdf"}
      cset = Folder.changeset(tmap, attr)
      cqry = from(t in "folders", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert Repo.one(cqry) == 1
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:folder)
    end

    test "inserting an entity" do
      cqry = from(t in "folders", select: count(t.id))
      assert Repo.one(cqry) == 0
      assert insert(:folder)
      assert Repo.one(cqry) == 1
    end

    test "inserting two entities" do
      fqry = from(t in "folders", select: count(t.id))
      uqry = from(t in "users", select: count(t.id))
      assert Repo.one(fqry) == 0
      assert insert(:folder)
      assert insert(:folder)
      assert Repo.one(fqry) == 2
      assert Repo.one(uqry) == 2
    end

    test "uses alternate attrs" do
      cqry = from(t in "folders", select: count(t.id))
      altname = "NEWNAME"
      assert Repo.one(cqry) == 0
      assert trak = insert(:folder, %{name: altname})
      assert Repo.one(cqry) == 1
      assert trak.name == altname
    end
  end

  describe "deleting records" do
    test "all folders" do
      cqry = from(t in "folders", select: count(t.id))
      assert Repo.one(cqry) == 0
      insert(:folder)
      assert Repo.one(cqry) == 1
      Repo.delete_all(Folder)
      assert Repo.one(cqry) == 0
    end
  end

  describe "user association" do
    test "finds the user from the folder" do
      fusr =
        from(f in "folders",
          join: u in "users",
          on: [id: f.user_id],
          select: {f.name, u.name}
        )
      insert(:folder)
      result = Repo.all(fusr)
      assert Enum.count(result) == 1
    end

    test "finds the folder from the user" do
      ufold =
        from(u in "users",
          join: f in "folders",
          on: u.id == f.user_id,
          select: {f.name, u.name}
        ) 
      insert(:folder)
      result = Repo.all(ufold)
      assert Enum.count(result) == 1
    end
  end
end
