defmodule FeedexCore.Metrics.InspectHandler do

  @moduledoc """
  Inspect Handler
  """

  @vm_memory [:vm, :memory]
  @vm_total_run_queue_lengths [:vm, :total_run_queue_lengths]
  @feedex_core_repo_query [:feedex_core, :repo, :query]
  @phoenix_endpoint_stop [:feedex, :endpoint, :stop]

  def setup do
    events = [
      @vm_memory, 
      @vm_total_run_queue_lengths, 
      @feedex_core_repo_query, 
      @phoenix_endpoint_stop
    ]

    :telemetry.attach_many(
      "inspect-reporter",
      events,
      &handle_event/4,
      nil
    )
  end
  
  def handle_event(@vm_memory, measurements, metadata, _cfg) do
    IO.inspect "+++++++++++++++++++++++++++++++++++++++"
    IO.inspect @vm_memory
    IO.inspect measurements
    IO.inspect metadata
    IO.inspect "+++++++++++++++++++++++++++++++++++++++"
  end

  def handle_event(@vm_total_run_queue_lengths, measurements, metadata, _cfg) do
    IO.inspect "======================================="
    IO.inspect @vm_total_run_queue_lengths
    IO.inspect measurements
    IO.inspect metadata
    IO.inspect "======================================="
  end

  def handle_event(@feedex_core_repo_query, measurements, metadata, _cfg) do
    IO.inspect "+++++++++++++++++++++++++++++++++++++++"
    IO.inspect @feedex_core_repo_query
    IO.inspect measurements
    IO.inspect metadata
    IO.inspect "+++++++++++++++++++++++++++++++++++++++"
  end

  def handle_event(@phoenix_endpoint_stop, measurements, metadata, _cfg) do
    IO.inspect "======================================="
    IO.inspect @phoenix_endpoint_stop
    IO.inspect measurements
    IO.inspect metadata
    IO.inspect "======================================="
  end
end
