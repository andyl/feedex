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

    # IO.puts "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    # IO.inspect metric, label: "NAME"
    # IO.inspect values, label: "PAKG"
    # IO.puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
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

  # defp handle_event(event_name, measurements, metadata, {metrics, device}) do
  #   prelude = """
  #   [#{inspect(__MODULE__)}] ----- NEW EVENT -----
  #   Event name: #{Enum.join(event_name, ".")}
  #   All measurements: #{inspect(measurements)}
  #   All metadata: #{inspect(metadata)}
  #   """
  #
  #   parts =
  #     for %struct{} = metric <- metrics do
  #       header = """
  #
  #       Metric measurement: #{inspect(metric.measurement)} (#{metric(struct)})
  #       """
  #
  #       [
  #         header
  #         | try do
  #             measurement = extract_measurement(metric, measurements, metadata)
  #             tags = extract_tags(metric, metadata)
  #
  #             cond do
  #               is_nil(measurement) ->
  #                 """
  #                 Measurement value missing (metric skipped)
  #                 """
  #
  #               not keep?(metric, metadata) ->
  #                 """
  #                 Event dropped
  #                 """
  #
  #               metric.__struct__ == Telemetry.Metrics.Counter ->
  #                 """
  #                 Tag values: #{inspect(tags)}
  #                 """
  #
  #               true ->
  #                 """
  #                 With value: #{inspect(measurement)}#{unit(metric.unit)}#{info(measurement)}
  #                 Tag values: #{inspect(tags)}
  #                 """
  #             end
  #           rescue
  #             e ->
  #               Logger.error([
  #                 "Could not format metric #{inspect(metric)}\n",
  #                 Exception.format(:error, e, __STACKTRACE__)
  #               ])
  #
  #               """
  #               Errored when processing (metric skipped - handler may detach!)
  #               """
  #           end
  #       ]
  #     end
  #
  #   IO.puts(device, [prelude | parts])
  # end

  # defp keep?(%{keep: nil}, _metadata), do: true
  # defp keep?(metric, metadata), do: metric.keep.(metadata)
  #
  # defp extract_measurement(metric, measurements, metadata) do
  #   case metric.measurement do
  #     fun when is_function(fun, 2) -> fun.(measurements, metadata)
  #     fun when is_function(fun, 1) -> fun.(measurements)
  #     key -> measurements[key]
  #   end
  # end
  #
  # defp info(int) when is_number(int), do: ""
  # defp info(_), do: " (WARNING! measurement should be a number)"
  #
  # defp unit(:unit), do: ""
  # defp unit(unit), do: " #{unit}"
  #
  # defp metric(Telemetry.Metrics.Counter), do: "counter"
  # defp metric(Telemetry.Metrics.Distribution), do: "distribution"
  # defp metric(Telemetry.Metrics.LastValue), do: "last_value"
  # defp metric(Telemetry.Metrics.Sum), do: "sum"
  # defp metric(Telemetry.Metrics.Summary), do: "summary"
  #
  # defp extract_tags(metric, metadata) do
  #   tag_values = metric.tag_values.(metadata)
  #   Map.take(tag_values, metric.tags)
  # end

end
