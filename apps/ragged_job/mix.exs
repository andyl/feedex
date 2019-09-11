defmodule RaggedJob.MixProject do
  use Mix.Project

  def project do
    [
      app: :ragged_job,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {RaggedJob.Application, []},
      extra_applications: [:logger, :runtime_tools, :timex]
    ]
  end

  defp deps do
    [
      {:ragged_client, in_umbrella: true},
      {:ragged_data, in_umbrella: true},
      {:quantum, "~> 2.3"},
      {:timex, "~> 3.0"},
    ]
  end
end
