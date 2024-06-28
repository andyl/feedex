defmodule FeedexWeb.Metrics.InfluxReporter do

  use GenServer
  require Logger

  def start_link(opts) do
    server_opts = Keyword.take(opts, [:name])
    device = opts[:device] || :stdio

    metrics =
      opts[:metrics] ||
        raise ArgumentError, "the :metrics option is required by #{inspect(__MODULE__)}"

    GenServer.start_link(__MODULE__, {metrics, device}, server_opts)
  end

  @impl true
  def init({metrics, device}) do
    Process.flag(:trap_exit, true)
    groups = Enum.group_by(metrics, & &1.event_name)

    for {event, metrics} <- groups do
      id = {__MODULE__, event, self()}
      :telemetry.attach(id, event, &handle_event/4, {metrics, device})
    end

    {:ok, Map.keys(groups)}
  end

  @impl true
  def terminate(_, events) do
    for event <- events do
      :telemetry.detach({__MODULE__, event, self()})
    end

    :ok
  end

  defp handle_event(event_name, measurements, _metadata, _action_pair) do
    pkg = %{
      event_name: event_name,
      measurements: measurements,
    }
    dispatch(FcTesla.tsdb_dbhost(), pkg)
  end

  defp dispatch({nil, nil}, _) do
  end

  defp dispatch(_dbhost, pkg) do
    metric = pkg.event_name |> metric_name()
    values = pkg.measurements |> value()
    line="#{metric} #{values}"
    FcTesla.metrics_post(line)
  end

  defp metric_name(metric) do
    metric
    |> Enum.map(&to_string/1)
    |> Enum.join("_")
  end

  defp value(measurements) do
    measurements
    |> Enum.map(fn({k, v}) -> "#{k}=#{v}" end)
    |> Enum.join(",")
  end

end
