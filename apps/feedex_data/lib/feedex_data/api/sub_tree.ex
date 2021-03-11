defmodule FeedexData.Api.SubTree do
  @moduledoc """
  Utilities for working with Subscription Trees.

  List all folders and reg_feeds for a user.
  """

  alias FeedexData.Ctx.Account.Folder
  alias FeedexData.Ctx.Account.Register
  alias FeedexData.Ctx.News.Feed
  alias FeedexData.Repo
  alias Modex.AltMap
  import Ecto.Query

  def list(user_id) do
    user_id
    |> query()
    |> Repo.all()
    |> convert()
  end

  def cleantree(user_id) do
    rawtree(user_id) 
    |> AltMap.retake([:id, :name, :user_id, :registers])
  end

  def rawtree(user_id) do
    rq = from(r in Register, order_by: r.name, select: %{folder_id: r.folder_id, id: r.id, name: r.name})

    from(
      f in Folder,
      where: f.user_id == ^user_id,
      order_by: f.name,
      preload: [registers: ^rq]
    )
    |> Repo.all()
  end

  def import(_tdata) do
    :ok
  end

  def import_json(_json) do
    :ok
  end
  
  defp query(user_id) do
    from(fld in Folder,
      left_join: reg in Register,
      on: fld.id == reg.folder_id,
      left_join: fee in Feed,
      on: fee.id == reg.feed_id,
      where: fld.user_id == ^user_id,
      order_by: [fld.name, reg.name],
      select: {fld.name, reg.name, fee.url}
    )
  end

  defp convert(list) do
    list
    |> Enum.reduce(%{}, fn el, acc -> update_lst(el, acc) end)
  end

  defp update_lst({folder_name, fname, furl}, map) do
    list1 = if fname, do: [%{feed_name: fname, feed_url: furl}], else: []
    list2 = (map[folder_name] || []) ++ list1
    Map.merge(map, %{folder_name => list2})
  end
end
