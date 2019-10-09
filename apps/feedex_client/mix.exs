defmodule FeedexClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :feedex_client,
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
      extra_applications: [
        :elixir_feed_parser, 
        :logger
      ]
    ]
  end

  defp deps do
    [
      {:httpotion, "~> 3.1.0"},
      {:elixir_feed_parser, github: "andyl/elixir-feed-parser"},
      {:exvcr, "~> 0.10", only: [:test]}
    ]
  end
end
