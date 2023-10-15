defmodule Feedex.MixProject do
  use Mix.Project

  def project do
    [
      app: :feedex,
      version: "0.0.1",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),

      # Docs
      name: "Feedex",
      source_url: "https://github.com/andyl/feedex",
      homepage_url: "http://TBD",
      docs: [
        main: "Feedex",
        logo: "priv/static/images/rss-4-32.png",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      mod: {Feedex.Application, []},
      extra_applications: extra_apps()
    ]
  end

  # Specifies extra_applications per environment.
  defp extra_apps do
    case Mix.env() do
      :test -> [:logger, :runtime_tools]
      _ -> [:logger, :runtime_tools, :os_mon]
    end
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Web Server
      {:plug_cowboy, "~> 2.0"},
      # Web UI
      {:swoosh,                 "~> 1.3"},
      {:phoenix,                "~> 1.7"},
      {:phoenix_ecto,           "~> 4.4"},
      {:phoenix_live_dashboard, "~> 0.7"},
      {:phoenix_html,           "~> 3.0"},
      {:phoenix_live_view,      "~> 0.18"},
      {:phoenix_live_reload,    "~> 1.2", only: :dev},
      {:heroicons,              "~> 0.5"},
      {:gettext,                "~> 0.20"},
      {:esbuild,                "~> 0.5", runtime: Mix.env() == :dev},
      {:tailwind,               "~> 0.2", runtime: Mix.env() == :dev},
      # Testing
      {:ex_machina, "~> 2.7"},
      {:floki,      ">= 0.30.0", only: :test},
      # Documentation
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      # Util
      {:bcrypt_elixir, "~> 3.0"},
      {:pbkdf2_elixir, "~> 2.0"},
      {:modex, github: "andyl/modex"},
      # Repo
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      # Telemetry
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller,  "~> 1.0"},
      {:ecto_psql_extras,  "~> 0.6"},
      # {:prom_ex,           "~> 1.9"},
      # Fc
      {:jason, "~> 1.2"},
      # FcFinch
      {:finch, "~> 0.13"},
      # FcTesla
      {:tesla,   "~> 1.4"},
      {:hackney, "~> 1.18"},
      # FcRss
      {:elixir_feed_parser, github: "andyl/elixir-feed-parser"},
      {:exvcr, "~> 0.12", only: [:test]},
      # FeedexJob
      {:quantum, "~> 3.3"},
      {:timex, "~> 3.0"},
      # Persistence
      {:pets, github: "andyl/pets"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
