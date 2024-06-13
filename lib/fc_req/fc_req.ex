defmodule FcReq do
  @moduledoc """
  Documentation for `FcReq`.
  """

  def fc_get(url, opt \\ []) do
    result = Req.get(url, opt)
    case result do
      {:ok, resp} -> resp
      alt -> alt
    end
  end

  # def fc_success?(%Req.Env{status: code}) do
  #   code in 200..299
  # end
  #
  # def fc_success?(_unknown) do
  #   false
  # end

  def hello do
    :world
  end

end
