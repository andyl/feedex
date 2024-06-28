defmodule FcTesla.InfluxV1 do
  @moduledoc """
  Utilities for posting metrics to InfluxDB V1.
  """

  use Tesla

  plug Tesla.Middleware.FormUrlencoded
  plug Tesla.Middleware.BasicAuth,
    username: tsdb_username(), password: tsdb_password()

  def influx_post(db, line) do
    body = line
    url  = "http://localhost:8086/write?db=#{db}&time_precision=s"
    case post(url, body) do
      {:ok, response} -> response
      error -> error
    end
  end

  def metrics_post(line) do
    body = line
    url  = "http://#{tsdb_host()}:8086/write?db=#{tsdb_db()}&time_precision=s"
    case post(url, body) do
      {:ok, response} -> response
      error -> error
    end
  end

  def success?(%Tesla.Env{status: code}) do
    code in 200..299
  end

  def success?(_unknown) do
    false
  end

  defp tsdb_db do
    Application.get_env(:feedex, FeedexTsdb)[:db]
  end

  defp tsdb_host do
    Application.get_env(:feedex, FeedexTsdb)[:host]
  end

  def tsdb_dbhost do
    {tsdb_db(), tsdb_host()}
  end

  defp tsdb_username do
    Application.get_env(:feedex, FeedexTsdb)[:username] || "admin"
  end

  defp tsdb_password do
    Application.get_env(:feedex, FeedexTsdb)[:password] || "admin123"
  end
end
