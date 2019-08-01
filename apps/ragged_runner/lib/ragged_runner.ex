defmodule RaggedRunner do
  @moduledoc """
  Background job scheduler / runner.

  Parameters:
  - state: on/off (default off)
  - cycle_frequency - seconds between cycles (default 300)
  - max_concurrent_jobs - default 5
  - min_update_frequency - default every 30 minutes

  Config params specified at startup.
  """

  def hello do
    :world
  end

  @doc """
  Start the RaggedRunner.
  """
  def start do
  end

  @doc """
  Stop the RaggedRunner.
  """
  def stop do
  end

  def config_show do
  end

  def config_update do
  end

  # defp select_jobs do
  #   RaggedData.Ctx.News.stale_feeds(config)
  # end
end
