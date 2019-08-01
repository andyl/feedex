# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :ragged_data,
  ecto_repos: [RaggedData.Repo]

config :ragged_web,
  generators: [context_app: false]

config :mix_test_watch, clear: true

# Configures the endpoint
config :ragged_web, RaggedWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7+ofwaUftnfag5VLUeS90Hs50uMUOWmTbbh3Kx2GGeFNPyizWJTI6clwH/0VV8NX",
  render_errors: [view: RaggedWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RaggedWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :ragged_web, RaggedWeb.Endpoint, live_view: [signing_salt: "asdf"]

