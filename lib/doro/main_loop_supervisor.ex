defmodule Doro.MainLoopSupervisor do
  require Logger
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], [])
  end

  def init(_) do
    children = [
      worker(Registry, [[keys: :unique, name: Doro.Registry]]),
      worker(Doro.World.GameState, []),
      worker(Doro.Parser, []),
      worker(Doro.Heartbeat, []),
      worker(Doro.Phenomena, [])
    ]

    children =
      case Doro.Transports.Slack.api_key() do
        nil -> children
        _ -> children ++ [worker(Doro.Transports.Slack, [])]
      end

    Supervisor.init(children, strategy: :one_for_one, name: __MODULE__)
  end
end
