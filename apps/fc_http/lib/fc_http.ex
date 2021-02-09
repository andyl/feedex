defmodule FcHttp do
  @moduledoc """
  Documentation for `FcHttp`.
  """

  @doc """
  Posts to a URL
  """
  def post(url, opt) do
    HTTPotion.post(url, opt)
  end

  def get(url, opt) do
    HTTPotion.get(url, opt)
  end

  def success?(response) do
    HTTPotion.Response.success?(response)
  end

  def start do
    HTTPotion.start()
  end
end
