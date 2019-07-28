use Mix.Config

# Configure your database
config :ragged_data, RaggedData.Repo,
  username: "postgres",
  password: "postgres",
  database: "ragged_data_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ragged_web, RaggedWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :error
