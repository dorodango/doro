defmodule Doro.MainLoopSupervisor do
  require Logger
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      {Registry, keys: :unique, name: Doro.Registry},
      Doro.World.GameState,
      Doro.Parser,
      Doro.Heartbeat,
      Doro.Phenomena
    ]

    children =
      case Doro.Transports.Slack.api_key() do
        nil -> children
        _ -> children ++ [Doro.Transports.Slack]
      end

    Supervisor.init(children, strategy: :one_for_one, name: __MODULE__)
  end
end
