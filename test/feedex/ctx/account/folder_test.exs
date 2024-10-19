defmodule Feedex.Ctx.Account.FolderTest do
  # , async: true
  use ExUnit.Case
  use Feedex.DataCase

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
      clear_all(Folder)
      tmap = %Folder{}
      attr = %{name: "asdf"}
      cset = Folder.changeset(tmap, attr)
      assert count(Folder) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert count(Folder) == 1
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:folder)
    end

    test "inserting an entity" do
      clear_all(Folder)
      assert count(Folder) == 0
      assert insert(:folder)
      assert count(Folder) == 1
    end

    test "inserting two entities" do
      clear_all([User, Folder])
      fqry = from(t in "folders", select: count(t.id))
      uqry = from(t in "users", select: count(t.id))
      assert Repo.one(fqry) == 0
      assert insert(:folder)
      assert insert(:folder)
      assert Repo.one(fqry) == 2
      assert Repo.one(uqry) == 2
    end

    test "uses alternate attrs" do
      clear_all(Folder)
      altname = "NEWNAME"
      assert count(Folder) == 0
      assert trak = insert(:folder, %{name: altname})
      assert count(Folder) == 1
      assert trak.name == altname
    end
  end

  describe "deleting records" do
    test "all folders" do
      clear_all(Folder)
      assert count(Folder) == 0
      insert(:folder)
      assert count(Folder) == 1
      Repo.delete_all(Folder)
      assert count(Folder) == 0
    end
  end

  describe "duplicate folder names" do
    test "raise error using factory" do
      clear_all([User, Folder])
      name = "bing"
      user = insert(:user)
      assert insert(:folder, user: user, name: name)
      assert_raise Ecto.ConstraintError, fn -> insert(:folder, user: user, name: name) end
    end

    test "invalid using changeset" do
      clear_all([User, Folder])
      name = "bing"
      user = insert(:user)
      assert insert(:folder, user: user, name: name)
      params = params_for(:folder, user: user, name: name)
      attrs = %Folder{} |> Folder.changeset(params)
      {:error, changeset} = Repo.insert(attrs)
      refute changeset.valid?
    end
  end

  describe "user association" do
    test "finds the user from the folder" do
      clear_all([User, Folder])

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
      clear_all([User, Folder])

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

  describe "#create_folder" do
    test "creates a folder" do
      clear_all([User, Folder])
      assert count(Folder) == 0
      user = insert(:user)
      result = Folder.create_folder(user.id, "asdf")
      assert result
      assert count(Folder) == 1
    end
  end

  describe "#update_folder" do
    test "updates a folder" do
      user = insert(:user)
      folder = Folder.create_folder(user.id, "asdf")
      new_folder = Folder.update_folder(folder, %{name: "tanker"})
      assert new_folder
    end
  end
end
