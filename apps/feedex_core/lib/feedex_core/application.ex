defmodule FeedexCore.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      FeedexCore.Repo
    ]

    current_env = Application.get_env(:feedex_core, :environment)
    if current_env != :test do
      # FeedexCore.Metrics.InspectHandler.setup()
      FeedexCore.Metrics.InfluxHandler.setup()
    end

    Supervisor.start_link(children, strategy: :one_for_one, name: FeedexCore.Supervisor)
  end
end
