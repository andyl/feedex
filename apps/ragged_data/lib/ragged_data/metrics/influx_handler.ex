defmodule RaggedData.Metrics.InfluxHandler do

  alias RaggedData.Influx

  def setup do
    events = [
      [:vm, :memory],
      [:vm, :total_run_queue_lengths],
      [:phoenix, :endpoint, :stop],
      [:ragged_data, :repo, :query]
    ]

    IO.inspect "======================================="
    IO.inspect "STARTING INFLUX TELEMETRY"
    IO.inspect events
    IO.inspect "======================================="

    :telemetry.attach_many(
      "inspect-reporter",
      events,
      &handle_event/4,
      nil
    )
  end
  
  def handle_event([:vm, :memory], fields, _metadata, _cfg) do
    measurement = "vm_memory"
    {:ok, host} = :inet.gethostname()
    Influx.write_point(measurement, fields, %{host: host})
  end

  def handle_event([:vm, :total_run_queue_lengths], fields, _metadata, _cfg) do
    measurement = "vm_total_run_queue_lengths"
    {:ok, host} = :inet.gethostname()
    Influx.write_point(measurement, fields, %{host: host})
  end

  def handle_event([:ragged_data, :repo, :query], fields, _metadata, _cfg) do
    measurement = "ragged_data_repo_query"
    {:ok, host} = :inet.gethostname()
    tags = %{
      host: host
    }
    Influx.write_point(measurement, fields, tags)
  end

  def handle_event([:phoenix, :endpoint, :stop], fields, params, _cfg) do
    measurement = "phoenix_endpoint_stop"
    {:ok, host} = :inet.gethostname()
    tags = %{
      path: Enum.join(params.conn.path_info, "/"),
      host: host
    }
    Influx.write_point(measurement, fields, tags)
  end
end
