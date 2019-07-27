defmodule RaggedClient do
  @moduledoc """
  An Elixir Client that pulls RSS Documents.


  """

  @doc """
  Probe.

  ## Examples

      iex> RaggedClient.probe("https://ragged.io")
      :ok

  """
  def probe(_url) do
    :ok
  end

  @doc """
  Get.

  ## Examples

      iex> RaggedClient.get("https://ragged.io/feed")
      :ok 

  """
  def get(_url) do
    :ok 
  end
end
