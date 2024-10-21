defmodule Util.StreamCmd do
  def run(command) do
    Application.put_env(:elixir, :ansi_enabled, true)

    port =
      Port.open({:spawn, command}, [
        :binary,
        :exit_status,
        :stderr_to_stdout,
        :use_stdio,
        {:env,
         [
           {~c"TERM", ~c"xterm-256color"},
           {~c"MIX_ENV", ~c"test"},
           {~c"FORCE_COLOR", ~c"true"},
           {~c"CLICOLOR_FORCE", ~c"1"},
           {~c"NO_COLOR", ~c""}
         ]}
      ])

    stream_output(port)
  end

  defp stream_output(port) do
    receive do
      {^port, {:data, data}} ->
        IO.write(data)
        stream_output(port)

      {^port, {:exit_status, status}} ->
        status
    end
  end
end
