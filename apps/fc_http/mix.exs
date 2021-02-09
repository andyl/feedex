defmodule FcHttp.MixProject do
  use Mix.Project

  def project do
    [
      app: :fc_http,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:httpotion, :logger]
    ]
  end

  defp deps do
    [
      {:httpotion, "~> 3.1"}
    ]
  end
end
