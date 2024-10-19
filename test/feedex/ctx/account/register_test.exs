defmodule Feedex.Ctx.Account.RegisterTest do
  # , async: true
  use ExUnit.Case
  use Feedex.DataCase

  test "greet the world" do
    assert "hello" == "hello"
  end

  describe "changesets" do
    test "accepts valid input" do
      tmap = %Register{}
      attr = %{name: "asdf"}
      cs = Register.changeset(tmap, attr)
      assert cs.valid?
    end
  end

  describe "inserting records" do
    test "adds a record" do
      clear_all(Register)
      tmap = %Register{}
      attr = %{name: "asdf"}
      cset = Register.changeset(tmap, attr)
      assert count(Register) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert count(Register) == 1
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:register)
    end

    test "inserting an entity" do
      clear_all(Register)
      assert count(Register) == 0
      assert insert(:register)
      assert count(Register) == 1
    end

    test "inserting two entities" do
      clear_all(User)
      fqry = from(t in "registers", select: count(t.id))
      uqry = from(t in "users", select: count(t.id))
      assert Repo.one(fqry) == 0
      assert insert(:register)
      assert insert(:register)
      assert Repo.one(fqry) == 2
      assert Repo.one(uqry) == 2
    end

    test "uses alternate attrs" do
      clear_all(User)
      altname = "NEWNAME"
      assert count(Register) == 0
      assert trak = insert(:register, %{name: altname})
      assert count(Register) == 1
      assert trak.name == altname
    end
  end

  describe "deleting records" do
    test "all registers" do
      clear_all(Register)
      assert count(Register) == 0
      insert(:register)
      assert count(Register) == 1
      Repo.delete_all(Register)
      assert count(Register) == 0
    end
  end

  describe "folder association" do
    test "finds the folder from the register" do
      clear_all(Register)

      fusr =
        from(f in "registers",
          join: u in "folders",
          on: [id: f.folder_id],
          select: {f.name, u.name}
        )

      insert(:register)
      result = Repo.all(fusr)
      assert Enum.count(result) == 1
    end

    test "finds the register from the folder" do
      clear_all(Register)

      ufold =
        from(u in "folders",
          join: f in "registers",
          on: u.id == f.folder_id,
          select: {f.name, u.name}
        )

      insert(:register)
      result = Repo.all(ufold)
      assert Enum.count(result) == 1
    end
  end
end
