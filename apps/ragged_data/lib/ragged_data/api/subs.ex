defmodule RaggedData.Api.Subs do
  alias RaggedData.Ctx.Account.Folder
  alias RaggedData.Ctx.Account.Register
  alias RaggedData.Ctx.News.Feed
  alias RaggedData.Repo
  import Ecto.Query

  # ----- show -----
  
  def show(user_id) do
    user_id
    |> query()
    |> Repo.all()
    |> convert()
  end

  defp query(user_id) do
    from(fld in Folder,
      left_join: reg in Register, on: fld.id == reg.folder_id, 
      left_join: fee in Feed, on: fee.id == reg.feed_id,
      where: fld.user_id == ^user_id,
      order_by: [fld.name, reg.name],
      select: {fld.name, reg.name, fee.url} 
    )
  end

  defp convert(list) do
    list
    |> Enum.reduce(%{}, fn(el, acc) -> update_lst(el, acc) end)
  end

  defp update_lst({folder_name, fname, furl}, map) do
    list1 = if fname, do: [%{feed_name: fname, feed_url: furl}], else: []
    list2 = (map[folder_name] || []) ++ list1
    Map.merge(map, %{folder_name => list2})
  end
  
end
