defmodule Harvest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HarvestWeb.Telemetry,
      Harvest.Repo,
      {DNSCluster, query: Application.get_env(:harvest, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Harvest.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Harvest.Finch},
      # Optional: Add periodic sync
      # %{
      #   id: HarvesterSync,
      #   start: {
      #     Elixir.Task.Supervised,
      #     :start_link,
      #     [fn -> :timer.sleep(60_000); Harvest.Miners.sync_miners() end]
      #   }
      # },
      # Start a worker by calling: Harvest.Worker.start_link(arg)
      # {Harvest.Worker, arg},
      # Start to serve requests, typically the last entry
      HarvestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Harvest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HarvestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
