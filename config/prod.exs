use Mix.Config

config :feedex_data, FeedexData.Repo,
  username: "postgres",
  password: "postgres",
  database: "feedex_data_prod",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :feedex_data, FeedexData.Influx,
  database: "inf_feedex_prod"

# ---------------------------------------------------

config :feedex_web, FeedexWeb.Endpoint,
  url: [host: "localhost", port: 5060],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: false,
  server: true,
  root: "."

config :logger, level: :info

key = "veryverysecretkeyeryverysecretkeyveryverysecretkeyveryverysecretkey"
config :feedex_web, FeedexWeb.Endpoint,
  http: [:inet6, port: "5060"],
  secret_key_base: key

