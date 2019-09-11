defmodule Ragged.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.0.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  # def application do
  #   [
  #     mod: {Ragged.Application, []},
  #     extra_applications: [:logger, :runtime_tools, :timex]
  #   ]
  # end

  # Specifies which paths to compile per environment.
  # defp elixirc_paths(:test), do: ["lib", "test/support"]
  # defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # ----- deployment
      {:distillery, "~> 2.1", warn_missing: false},
      # ----- static analyzers
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      # ----- development and test
      {:scribe, "~> 0.10"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
