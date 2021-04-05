defmodule Feedex.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.0.1",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:mix_test_interactive]
    ]
  end

  defp deps do
    [
      # ----- static analyzers
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      # ----- development and test
      {:scribe, "~> 0.10", only: :dev, runtime: false},
      {:mix_test_interactive, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      # ----- release
      {:distillery, "~> 2.1", warn_missing: false}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
