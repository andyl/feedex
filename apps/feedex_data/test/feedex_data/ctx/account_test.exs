defmodule FeedexData.Ctx.AccountTest do 
  use ExUnit.Case
  use FeedexData.DataCase

  describe "#count" do
    test "valid results" do
      counts = Account.count()
      assert counts.user == 0
      assert counts.folder == 0
      assert counts.register == 0
    end
  end

  describe "#user_add" do
    test "valid user" do
      attr = %{name: "asdf", email: "qwer.com", pwd: "bingbing"}
      assert Account.count(User)== 0
      Account.user_add(attr)
      assert Account.count(User) == 1
    end

    test "missing password error" do
      attr = %{name: "asdf", email: "qwer.com"}
      assert Account.count(User) == 0
      Account.user_add(attr)
      assert Account.count(User) == 1
    end
  end
end
