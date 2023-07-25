defmodule ReadNever.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ReadNeverWeb.Telemetry,
      # Start the Ecto repository
      ReadNever.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ReadNever.PubSub},
      # Start Finch
      {Finch, name: ReadNever.Finch},
      # Start the Endpoint (http/https)
      ReadNeverWeb.Endpoint,
      BookCollect.Lifecycle.BookCollectSup
      # Start a worker by calling: ReadNever.Worker.start_link(arg)
      # {ReadNever.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReadNever.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ReadNeverWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
