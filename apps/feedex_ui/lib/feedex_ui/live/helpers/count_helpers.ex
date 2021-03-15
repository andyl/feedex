defmodule FeedexUi.CountHelpers do

  @moduledoc """
  HTML helpers for live views.
  """

  import Phoenix.HTML

  def unread(0), do: ""

  def unread(count) do
    """
    <span class="inline-flex items-center px-1 ml-1 text-xs font-light text-blue-800 align-text-top bg-blue-100 rounded-full dn-2">
      <small>
        #{count}
      </small>
    </span>
    """
  end

  def unread(count, :raw) do
    unread(count) |> raw()
  end

  def unread(id, unread_count) do
    unread(unread_count[id] || 0)
  end

  def unread(id, unread_count, :raw) do
      "ALL"
    unread(id, unread_count) |> raw()
  end

end
