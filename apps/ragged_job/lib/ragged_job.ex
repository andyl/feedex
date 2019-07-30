defmodule RaggedJob do
  def sync(url) do
    url
    |> RaggedClient.get()
    |> handle_data()
  end

  defp handle_data(result) do
    result
  end
end
