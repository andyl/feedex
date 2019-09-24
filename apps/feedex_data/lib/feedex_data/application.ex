defmodule FeedexData.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      FeedexData.Repo
    ]

    current_env = Application.get_env(:feedex_data, :environment)
    if current_env != :test do
      # FeedexData.Metrics.InspectHandler.setup()
      FeedexData.Metrics.InfluxHandler.setup()
    end

    Supervisor.start_link(children, strategy: :one_for_one, name: FeedexData.Supervisor)
  end
end
