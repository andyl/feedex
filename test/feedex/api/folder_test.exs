defmodule Feedex.Api.FolderTest do
  use ExUnit.Case, async: true
  use Feedex.DataCase

  alias Feedex.Api

  describe "#find_or_create_folder" do
    test "create a folder" do
      clear_all(Folder)
      name = "ping"
      user = insert(:user)
      assert count(Folder) == 0
      folder = Api.Folder.find_or_create_folder(user.id, name)
      assert folder
      assert folder.name == name
      assert count(Folder) == 1
    end

    test "find a folder" do
      clear_all([User, Folder])
      user = insert(:user)
      folder1 = insert(:folder, user: user)
      assert count(Folder) == 1
      folder2 = Api.Folder.find_or_create_folder(user.id, folder1.name)
      assert folder2
      assert folder2.id == folder1.id
      assert count(Folder) == 1
    end
  end

  describe "#by_id" do
    test "return a folder" do
      clear_all([User, Folder])
      user = insert(:user)
      folder1 = insert(:folder, user: user)
      assert count(Folder) == 1
      folder2 = Api.Folder.by_id(folder1.id)
      assert folder2
      assert folder2.id == folder1.id
    end
  end

  describe "#map_subset" do
    test "returns a map" do
      clear_all([User, Folder])
      user = insert(:user)
      folder1 = insert(:folder, user: user)
      assert count(Folder) == 1
      map1 = Api.Folder.map_subset(folder1, [:name, :stopwords])
      assert map1
    end
  end
end
