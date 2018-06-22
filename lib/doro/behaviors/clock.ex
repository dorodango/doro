defmodule Doro.Behaviors.Clock do
  require Logger
  use GenServer
  use Doro.Behavior
  import Doro.Comms

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :behavior_clock)
  end

  def init(args) do
    Phoenix.PubSub.subscribe(Doro.PubSub, "heartbeat")
    {:ok, args}
  end

  def handle_info({:heartbeat, t}, state) do
    if rem(t, 10) == 0 do
      Doro.World.entities_with_behavior(__MODULE__)
      |> Enum.each(fn clock -> tell_time(clock, t) end)
    end

    {:noreply, state}
  end

  defp tell_time(clock, t) do
    Doro.World.players_in_location(clock.props.location)
    |> Enum.each(&send_to_player(&1, "At the tone the time will be: #{t}"))
  end
end
