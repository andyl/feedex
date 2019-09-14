import Config

config :ragged_data,
  ecto_repos: [RaggedData.Repo]

config :ragged_web,
  generators: [context_app: false]

config :ragged_web, RaggedWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7+ofwaUftnfag5VLUeS90Hs50uMUOWmTbbh3Kx2GGeFNPyizWJTI6clwH/0VV8NX",
  render_errors: [view: RaggedWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RaggedWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :ragged_job, RaggedJob.Scheduler,
  jobs: [
    # {"* * * * *",      {Heartbeat, :send, []}},
    # {"*/15 * * * *",   fn -> System.cmd("rm", ["/tmp/tmp_"]) end},
    # {"0 18-6/2 * * *", fn -> :mnesia.backup('/var/backup/mnesia') end},
    # {"@daily",         {Backup, :backup, []}}
    # {"* * * * *",      {IO, :puts, ["CRON JOB"]}}
    {"*/3 * * * *",      {RaggedJob, :sync_next, []}}
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"

config :ragged_web, RaggedWeb.Endpoint, live_view: [signing_salt: "asdf"]

