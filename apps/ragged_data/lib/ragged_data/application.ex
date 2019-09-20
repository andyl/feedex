defmodule RaggedData.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      RaggedData.Influx,
      RaggedData.Repo
    ]

    # RaggedData.Metrics.InspectHandler.setup()

    Supervisor.start_link(children, strategy: :one_for_one, name: RaggedData.Supervisor)
  end
end
