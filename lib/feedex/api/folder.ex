defmodule Feedex.Api.Folder do
  @moduledoc """
  Utilities for working with Folders.
  """

  alias Feedex.Ctx.Account

  def find_or_create_folder(user_id, name) do
    Account.Folder.find_folder(user_id, name) || Account.Folder.create_folder(user_id, name)
  end

  def folder_validation_changeset(opts) do
    %Account.Folder{} |> Account.Folder.changeset(opts)
  end

  def map_subset(%_{} = folder, fields) do
    Map.from_struct(folder) |> Map.take(fields)
  end

  def map_subset(folder, fields) when is_map(folder) do
    Map.take(folder, fields)
  end

  def by_id_to_map(folder_id, fields) do
    by_id(folder_id) |> map_subset(fields)
  end

  defdelegate update_folder(folder, opts), to: Account.Folder
  defdelegate register_count(folder), to: Account.Folder
  defdelegate delete_folder(folder), to: Account.Folder
  defdelegate by_id(folder_id), to: Account.Folder

end
