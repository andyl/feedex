use Mix.Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

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

# ----- FeedexUi

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :feedex_ui, FeedexUi.Endpoint,
  http: [port: 4062],
  server: false

# ----- FeedexUi

# We don't run a server during test. If one is required,
# you can enable the server option below.
# config :feedex_web, FeedexWeb.Endpoint,
#   http: [port: 4062],
#   server: false

# Print only warnings and errors during test
config :logger, level: :warn


