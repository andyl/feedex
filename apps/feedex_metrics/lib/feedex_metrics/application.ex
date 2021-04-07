defmodule FeedexMetrics.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FeedexMetrics.Telemetry
      # Starts a worker by calling: FeedexMetrics.Worker.start_link(arg)
      # {FeedexMetrics.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FeedexMetrics.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
