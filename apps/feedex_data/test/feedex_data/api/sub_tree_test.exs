defmodule FeedexData.Api.SubTreeTest do
  use ExUnit.Case, async: true
  use FeedexData.DataCase

  alias FeedexData.Api.SubTree


  describe "#rawtree" do
    test "returns a value" do
      data = gentree()
      assert SubTree.rawtree(data.user.id)
    end
  end

  describe "#cleantree" do
    test "returns a value" do
      data = gentree()
      assert SubTree.cleantree(data.user.id)
    end
  end

  describe "#list" do
    test "returns a value" do
      data = gentree()
      assert SubTree.list(data.user.id)
    end
  end

  defp gentree do
    user = insert(:user)
    fld1 = insert(:folder, user: user)
    fld2 = insert(:folder, user: user)
    reg1 = insert(:register, folder: fld1)
    reg2 = insert(:register, folder: fld1)
    %{user: user, fld1: fld1, fld2: fld2, reg1: reg1, reg2: reg2}
  end
end
