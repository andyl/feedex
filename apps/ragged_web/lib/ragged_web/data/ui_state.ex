defmodule RaggedWeb.Data.UiState do
  @ctx %{filepath: "/tmp/ui_state.dat", tablekey: :uistate}

  use TypedStruct

  # modes: view, edit, add_feed, add_folder
  # folder_state: open, closed
  # post_state: open, closed

  typedstruct do
    field :user_id, integer(), enforce: true
    field :mode, String.t(), default: "view"
    field :folder_id, integer()
    field :folder_state, String.t(), default: "closed"
    field :feed_id, integer()
    field :post_id, integer()
    field :post_state, String.t(), default: "closed"
  end

  alias RaggedWeb.Data.UiState

  @moduledoc """
  Persistent store for User's UiState.

  One record per userid.
  """

  @doc """
  Save the UiState

  Every time a link is accesses, save an event-payload into the log-store.
  """
  def save(state, ctx \\ @ctx) do
    start_data_store(ctx)
    payload = %UiState{} | state
    Pets.insert(ctx.tablekey, {payload.user_id, payload})
  end

  @doc """
  Return the UiState for a given user_id.
  """
  def lookup(user_id, ctx \\ @ctx) do
    start_data_store(ctx)
    case Pets.lookup(ctx.tablekey, user_id) do
      [] -> %UiState{} | %{user_id: user_id}
      [{_, ui_state}] -> uistate
      _ -> raise("Error: badval")
    end
  end

  @doc """
  Return all records.
  """
  def all(ctx \\ @ctx) do
    start_data_store(ctx)
    Pets.all(ctx.tablekey)
    |> Enum.map(&(elem(&1, 1)))
  end

  defp start_data_store(ctx) do
    unless Pets.started?(ctx.tablekey),
      do: Pets.start(ctx.tablekey, ctx.filepath, [:ordered_set])
  end
end
