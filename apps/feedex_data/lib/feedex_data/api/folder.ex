defmodule FeedexData.Api.Folder do
  @moduledoc """
  Utilities for working with Folders.
  """

  alias FeedexData.Ctx.Account.Folder
  alias FeedexData.Repo

  def create_folder(user_id, name) do
    params = %Folder{user_id: user_id, name: name}
    Repo.insert(params)
  end

  def folder_validation_changeset(name) do
    params = %{name: name}
    %Folder{} |> Folder.changeset(params)
  end
  
end
