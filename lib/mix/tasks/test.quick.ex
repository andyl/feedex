defmodule Mix.Tasks.Test.Quick do
  use Mix.Task

  @timestamp_file "priv/.last_fulltest_run"

  @shortdoc "Run tests if source has changed since last successful full test run"

  def run(args) do
    IO.inspect(args, label: "TEST.QUICK")

    if should_run_tests?() do
      Application.put_env(:elixir, :ansi_enabled, true)
      cmd = "mix test --color " <> Enum.join(args, " ")
      result = Util.StreamCmd.run(cmd)

      if all_tests_run?(args) && tests_passed?(result) do
        write_timestamp()
      end

      result
    else
      IO.puts("ALL TESTS PASS")
      0
    end
  end

  defp should_run_tests? do
    case {get_latest_source_mod_time(), get_last_test_time()} do
      {_source_time, nil} ->
        true

      {source_time, test_time} ->
        NaiveDateTime.compare(source_time, test_time) == :gt
    end
  end

  defp get_latest_source_mod_time do
    Path.wildcard("{lib,test}/**/*.{ex,exs}")
    |> Enum.map(&File.stat!(&1).mtime)
    |> Enum.max_by(&NaiveDateTime.from_erl!/1)
    |> NaiveDateTime.from_erl!()
  end

  defp get_last_test_time do
    case File.read(@timestamp_file) do
      {:ok, content} -> NaiveDateTime.from_iso8601!(String.trim(content))
      {:error, _} -> nil
    end
  end

  defp all_tests_run?(args) do
    Enum.empty?(args) || Enum.all?(args, &(not String.ends_with?(&1, ".exs")))
  end

  defp tests_passed?(result) do
    result == 0
  end

  defp write_timestamp do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.to_string()
    File.write(@timestamp_file, timestamp)
  end
end
