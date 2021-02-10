use Mix.Config

# ----- FeedexTsdb

config :feedex_tsdb, FeedexTsdb,
  database: "inf_feedex_cypress"

# ----- FeedexData

config :feedex_data, FeedexData.Repo,
  username: "postgres",
  password: "postgres",
  database: "feedex_data_cypress",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# ----- FeedexWeb 

# Endpoint
config :feedex_web, FeedexWeb.Endpoint,
  http: [port: 4063],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../apps/feedex_web/assets", __DIR__)
    ]
  ]
  
# Watch static and templates for browser reloading.
config :feedex_web, FeedexWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/feedex_web/(live|views)/.*(ex)$",
      ~r"lib/feedex_web/templates/.*(eex)$"
    ]
  ]

# ----- Misc

# Print only warnings and errors during cypress
config :logger, level: :warn
