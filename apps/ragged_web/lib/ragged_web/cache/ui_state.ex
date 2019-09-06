defmodule RaggedWeb.Cache.UiState do
  # modes: view, edit, add_feed, add_folder
  # folder_state: open, closed
  # post_state: open, closed

  defstruct user_id: nil,
            mode: "view",
            folder_id: nil,
            folder_state: "closed",
            feed_id: nil,
            post_id: nil,
            post_state: "closed",
            timestamp: Timex.now()

  alias RaggedWeb.Cache.UiState

  @moduledoc """
  Persistent store for User's UiState.

  One record per userid.
  """

  @doc """
  Save the UiState

  Every time a link is accesses, save an event-payload into the log-store.
  """
  def save(state = %{}) do
    payload = struct(UiState, state)

    sig()
    |> Pets.insert({payload.user_id, payload})
  end

  @doc """
  Return the UiState for a given user_id.
  """
  def lookup(user_id) do
    result = Pets.lookup(sig(), user_id)

    case result do
      [] -> %UiState{user_id: user_id}
      nil -> %UiState{user_id: user_id}
      [{_, uistate}] -> uistate
      _ -> raise("Error: badval")
    end
  end

  @doc """
  Return all records.
  """
  def all do
    sig()
    |> Pets.all()
    |> Enum.map(&elem(&1, 1))
  end

  def cleanup do
    sig()
    |> Pets.cleanup()
  end

  @env Mix.env()
  defp sig do
    case @env do
      :dev -> %{filepath: "/tmp/uistate_dev.dat", tablekey: :uistate_dev}
      :test -> %{filepath: "/tmp/uistate_test.dat", tablekey: :uistate_test}
      :prod -> %{filepath: "/tmp/uistate_prod.dat", tablekey: :uistate_prod}
    end
  end
end
