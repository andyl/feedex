defmodule RaggedJob do
  @moduledoc """
  Fetches data live and scheduled.
  """

  @doc """
  Add URL to system, if a valid Feed is found.

  Called by `Account#add_feed`.
  """
  def scan(_url) do
  end

  def update(url) do
    url
    |> RaggedClient.get()
    |> handle_data()
  end

  defp handle_data(result) do
    result
  end
end
