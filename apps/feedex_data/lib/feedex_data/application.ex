defmodule FeedexData.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      FeedexData.Repo
    ]

    current_env = Application.get_env(:feedex_data, :environment) || Mix.env()
    if current_env == :prod || current_env == :dev do
      # FeedexData.Metrics.InspectHandler.setup()
      FeedexData.Metrics.InfluxHandler.setup()
    end

    Supervisor.start_link(children, strategy: :one_for_one, name: FeedexData.Supervisor)
  end
end
