defmodule FeedexJob.Application do
  @moduledoc false

  use Application

  def child_spec(_) do
    %{
      id: :feedex_job,
      start: {__MODULE__, :start, []},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start() do
    start(:x, :y)
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      FeedexJob.Scheduler
    ]

    opts = [strategy: :one_for_one, name: FeedexJob.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
