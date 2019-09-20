defmodule RaggedData.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      RaggedData.Influx,
      RaggedData.Repo
    ]

    IO.inspect "---------------------------------------"
    current_env = Application.get_env(:ragged_data, :environment) || Mix.env()
    IO.inspect current_env
    if current_env == :prod || current_env == :dev do
      IO.inspect "======================================="
      IO.inspect "STARTING INFLUX TELEMETRY"
      IO.inspect "======================================="
      # RaggedData.Metrics.InspectHandler.setup()
      RaggedData.Metrics.InfluxHandler.setup()
    end
    IO.inspect "---------------------------------------"

    Supervisor.start_link(children, strategy: :one_for_one, name: RaggedData.Supervisor)
  end
end
