defmodule RaggedData.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      RaggedData.Influx,
      RaggedData.Repo
    ]

    current_env = Application.get_env(:ragged_data, :environment)
    if current_env == :prod || current_env == :dev do
      # RaggedData.Metrics.InspectHandler.setup()
      RaggedData.Metrics.InfluxHandler.setup()
    end

    Supervisor.start_link(children, strategy: :one_for_one, name: RaggedData.Supervisor)
  end
end
