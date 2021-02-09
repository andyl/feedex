use Mix.Config

# ----- FeedexTsdb

config :feedex_tsdb, FeedexTsdb,
  database: "inf_feedex_test"

# ----- FeedexData

config :feedex_data, FeedexData.Repo,
  username: "postgres",
  password: "postgres",
  database: "feedex_data_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :feedex_web, FeedexWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
