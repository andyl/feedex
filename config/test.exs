use Mix.Config

# Configure your database
config :feedex_data, FeedexData.Repo,
  username: "postgres",
  password: "postgres",
  database: "feedex_data_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :feedex_web, FeedexWeb.Endpoint,
  http: [port: 4001],
  server: true

config :hound, driver: "chrome_driver", browser: "chrome_headless"

config :logger, level: :error
