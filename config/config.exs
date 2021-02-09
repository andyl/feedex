# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.

use Mix.Config

# ----- FeedexData 

config :feedex_data,
  ecto_repos: [FeedexData.Repo],
  env: Mix.env()

# ----- FeedexWeb 

config :feedex_web,
  generators: [context_app: :feedex]

# Configures the endpoint
config :feedex_web, FeedexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3C/yQ+COfkrrV8JK0oqTM5k0QtpDYU5lQOe3yd2/pzjBMquux9ki7wJZXsZGklZu",
  render_errors: [view: FeedexWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Feedex.PubSub,
  live_view: [signing_salt: "gdYZay/D"]

# ----- Misc 
  
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
