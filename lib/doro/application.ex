defmodule Doro.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Doro.Repo, []),
      # Start the endpoint when the application starts
      supervisor(DoroWeb.Endpoint, []),
      # Start your own worker by calling: Doro.Worker.start_link(arg1, arg2, arg3)
      # worker(Doro.Worker, [arg1, arg2, arg3]),
      worker(Registry, [[keys: :unique, name: Doro.Registry]]),
      worker(Doro.World.GameState, []),
      worker(Doro.Parser, [])
    ]

    children =
      case Mix.env() do
        :test ->
          children

        _ ->
          children ++
            [
              worker(Doro.Transports.Slack, []),
              worker(Doro.Heartbeat, []),
              worker(Doro.Phenomena, [])
            ]
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Doro.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DoroWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
