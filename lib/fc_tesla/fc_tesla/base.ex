defmodule FcTesla.Base do
  @moduledoc """
  Documentation for `FcTesla`.
  """

  use Tesla

  plug Tesla.Middleware.FollowRedirects

  adapter(Tesla.Adapter.Finch, name: Feedex.Finch)

  def fc_post(url, opt \\ []) do
    result = post(url, opt) |> IO.inspect(label: "FC_POST")

    case result do
      {:ok, response} -> response
      error -> error
    end
  end

  def fc_get(url, opt \\ []) do
    result = get(url, opt) |> IO.inspect(label: "FC_GET")

    case result do
      {:ok, response} -> response
      error -> error
    end
  end

  def fc_success?(%Tesla.Env{status: code}) do
    code in 200..299
  end

  def fc_success?(_unknown) do
    false
  end
end
