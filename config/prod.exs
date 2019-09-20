use Mix.Config

config :ragged_data, RaggedData.Repo,
  username: "postgres",
  password: "postgres",
  database: "ragged_data_prod",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :ragged_data, RaggedData.Influx,
  database: "inf_ragged_prod"

# ---------------------------------------------------

config :ragged_web, RaggedWeb.Endpoint,
  url: [host: "localhost", port: 5060],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: false,
  server: true,
  root: "."

config :logger, level: :info

config :ragged_web, RaggedWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "5060")],
  secret_key_base: "veryverysecretkeyeryverysecretkeyveryverysecretkeyveryverysecretkey"

