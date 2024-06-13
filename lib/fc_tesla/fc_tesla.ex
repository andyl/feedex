defmodule FcTesla do
  @moduledoc """
  Documentation for `FcTesla`.
  """

  def metrics_post(line) do
    FcTesla.InfluxV1.metrics_post(line)
  end

  def influx_post(db, line) do
    FcTesla.InfluxV1.influx_post(db, line)
  end

  def tsdb_dbhost do
    FcTesla.InfluxV1.tsdb_dbhost()
  end

  def fc_get(url, opt \\ []) do
    result = FcTesla.Base.get(url, opt) |> IO.inspect(label: "ZINGG")
    case result do
      {:ok, resp} -> resp
      alt -> alt
    end
  end

  def fc_success?(%Tesla.Env{status: code}) do
    code in 200..299
  end

  def fc_success?(_unknown) do
    false
  end

  def hello do
    :world
  end

end
