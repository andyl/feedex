defmodule RaggedData.Metrics.InfluxHandler do

  def setup do
    events = [
      [:vm, :memory],
      # [:vm, :total_run_queue_lengths],
      # [:ragged_data, :repo, :query],
      # [:phoenix, :endpoint, :stop]
    ]

    :telemetry.attach_many(
      "inspect-reporter",
      events,
      &handle_event/4,
      nil
    )
  end
  
  def handle_event([:vm, :memory], measurements, metadata, _cfg) do
    IO.inspect "+++++++++++++++++++++++++++++++++++++++"
    IO.inspect measurements
    IO.inspect metadata
    IO.inspect "+++++++++++++++++++++++++++++++++++++++"
  end

  # def handle_event([:vm, :total_run_queue_lengths], measurements, metadata, _cfg) do
  #   IO.inspect "======================================="
  #   IO.inspect measurements
  #   IO.inspect metadata
  #   IO.inspect "======================================="
  # end

  def handle_event([:ragged_data, :repo, :query], _measurements, _metadata, _cfg) do
    # IO.inspect "+++++++++++++++++++++++++++++++++++++++"
    # IO.inspect measurements
    # IO.inspect metadata
    # IO.inspect "+++++++++++++++++++++++++++++++++++++++"
  end

  def handle_event([:phoenix, :endpoint, :stop], _measurements, _metadata, _cfg) do
    # IO.inspect "======================================="
    # IO.inspect measurements
    # IO.inspect metadata
    # IO.inspect "======================================="
  end
end
