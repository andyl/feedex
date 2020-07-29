import Config

config :feedex_data,
  ecto_repos: [FeedexData.Repo],
  env: Mix.env()

config :feedex_web,
  generators: [context_app: false],
  badger_tag: "Feedex",
  env: Mix.env()

config :feedex_web, FeedexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7+ofwaUftnfag5VLUeS90Hs50uMUOWmTbbh3Kx2GGeFNPyizWJTI6clwH/0VV8NX",
  render_errors: [view: FeedexWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FeedexWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :feedex_job,
  env: Mix.env()

config :feedex_job, FeedexJob.Scheduler,
  jobs: [
    # {"*/15 * * * *",   fn -> System.cmd("rm", ["/tmp/tmp_"]) end},
    # {"0 18-6/2 * * *", fn -> :mnesia.backup('/var/backup/mnesia') end},
    # {"@daily",         {Backup, :backup, []}}
    # {"* * * * *",      {IO, :puts, ["CRON JOB"]}}
    {"* * * * *",        {FeedexData.Metrics.AppPoller, :post_counts, []}},
    {"*/3 * * * *",      {FeedexJob, :sync_next, []}}
  ]

unless Mix.env() == :test do
  config :telemetry_poller, :default, vm_measurements: :default, period: 30_000
end

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"

config :feedex_web, FeedexWeb.Endpoint, live_view: [signing_salt: "asdf"]

config :phoenix_live_editable, css_framework: Phoenix.LiveEditable.Bootstrap4

