defmodule RaggedData.Ctx.AccountTest do 
  use ExUnit.Case, async: true
  alias RaggedData.Repo
  alias RaggedData.Ctx.Account
  alias RaggedData.Ctx.Account.User

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "#count" do
    test "valid results" do
      counts = Account.count()
      assert counts.user == 0
      assert counts.folder == 0
      assert counts.feed_log == 0
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
