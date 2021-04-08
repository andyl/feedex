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

# ----- FcTesla

config :tesla, adapter: Tesla.Adapter.Hackney

# ----- FeedexCore 

config :feedex_core,
  ecto_repos: [FeedexCore.Repo],
  env: Mix.env()

# ----- FeedexUi

config :feedex_ui,
  ecto_repos: [FeedexCore.Repo],
  generators: [context_app: :feedex_core, binary_id: true]

# Configures the endpoint
config :feedex_ui, FeedexUi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0J0y7WjjZbElQAjZnF8qFVV/4Cr21mwLWslASkMj/p5XyvRBWeNDlwKEVakFP8Ra",
  render_errors: [view: FeedexUi.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FeedexUi.PubSub,
  live_view: [signing_salt: "UPuxN9Ta"]

# ----- FeedexJob

config :feedex_job,
  env: Mix.env()

config :feedex_job, FeedexJob.Scheduler,
  jobs: [
    # {"*/15 * * * *",   fn -> System.cmd("rm", ["/tmp/tmp_"]) end},
    # {"0 18-6/2 * * *", fn -> :mnesia.backup('/var/backup/mnesia') end},
    # {"@daily",         {Backup, :backup, []}}
    # {"* * * * *",      {IO, :puts, ["CRON JOB"]}}
    # {"* * * * *",        {FeedexCore.Metrics.AppPoller, :post_counts, []}},
    # {"*/3 * * * *",      {FeedexJob, :sync_next, []}}
  ]

# ----- Testing

if Mix.env == :dev do
  config :mix_test_interactive, clear: true
end

# ----- Misc 
  
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Phoenix Live Editable
config :phoenix_live_editable, css_framework: Phoenix.LiveEditable.Ui.Bootstrap5

unless Mix.env() == :test do
  config :telemetry_poller, :default, vm_measurements: :default, period: 30_000
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

