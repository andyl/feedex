defmodule Mix.Tasks.Build do
  use Mix.Task

  @shortdoc "Builds the project and records the timestamp of the build"

  def run(_args) do
    # Record the current timestamp
    timestamp = DateTime.utc_now() |> Calendar.strftime("%y-%m-%d_%H:%M UTC")

    # Write the timestamp to a file
    File.write!("built_at.txt", timestamp)

    # Run the standard mix compile task
    Mix.Task.run("compile")
  end
end

