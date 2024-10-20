defmodule Feedex.Ctx.AccountTest do
  use ExUnit.Case
  use Feedex.DataCase, async: true

  describe "#count" do
    test "valid results" do
      clear_all(User)
      counts = Account.count()
      assert counts.user == 0
      assert counts.folder == 0
      assert counts.register == 0
    end
  end

  describe "#user_add" do
    test "valid user" do
      attr = %{name: "asdf", email: "qwer.com", pwd: "bingbing", hashed_password: "asdf"}
      clear_all(User)
      assert Account.count(User) == 0
      Account.user_add(attr)
      assert Account.count(User) == 1
    end

    test "missing password error" do
      attr = %{name: "asdf", email: "qwer.com"}
      clear_all(User)
      assert Account.count(User) == 0

      assert_raise Postgrex.Error, fn ->
        Account.user_add(attr)
      end

      assert Account.count(User) == 0
    end
  end
end
