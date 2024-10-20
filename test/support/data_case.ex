defmodule Feedex.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Feedex.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Feedex.Repo
  alias Feedex.Ctx.Account.{User, Folder, Register, ReadLog}
  alias Feedex.Ctx.News.{Feed, Post}

  require Ecto.Query

  using do
    quote do
      alias Feedex.Repo
      alias Feedex.Ctx.Account
      alias Feedex.Ctx.Account.{User, Folder, Register, ReadLog}
      alias Feedex.Ctx.News
      alias Feedex.Ctx.News.{Feed, Post}

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Feedex.DataCase
      import Feedex.Factory
    end
  end

  setup tags do
    Feedex.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Feedex.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  def clear_all(list) when is_list(list) do
    list |> Enum.map(&clear_all(&1))
  end

  def clear_all(type) do
    Feedex.Repo.delete_all(type)
  end

  def count(type) do
    Ecto.Query.from(element in type, select: count(element.id))
    |> Repo.one()
  end
end
