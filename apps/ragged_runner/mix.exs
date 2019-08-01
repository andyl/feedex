defmodule RaggedRunner.MixProject do
  use Mix.Project

  def project do
    [
      app: :ragged_runner,
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
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:oban, "~> 0.6.0"},
      {:ragged_job, in_umbrella: true}
    ]
  end
end
