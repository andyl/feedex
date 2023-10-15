defmodule Feedex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Feedex.PromEx,
      FeedexWeb.Telemetry,
      Feedex.Repo,
      {Phoenix.PubSub, name: Feedex.PubSub},
      {Finch, name: Feedex.Finch},
      FeedexWeb.Endpoint,
      {FeedexJob.Application, []},
      {FcFinch.Application, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Feedex.Supervisor]
    results = Supervisor.start_link(children, opts)

    Feedex.Seeds.load_if_empty()

    results
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FeedexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
