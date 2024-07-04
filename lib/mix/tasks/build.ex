defmodule Mix.Tasks.Build do
  use Mix.Task

  @shortdoc "Builds the project and records the timestamp of the build"

  def run(_args) do
    # Write build info to file
    Util.BuildInfo.write()

    # Run the standard mix compile task
    Mix.Task.run("compile")
  end
end

