defmodule Doro.Behaviors.Clock do
  require Logger
  use GenServer
  use Doro.Behavior

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :behavior_clock)
  end

  def init(args) do
    Phoenix.PubSub.subscribe(Doro.PubSub, "heartbeat")
    {:ok, args}
  end

  def handle_info({:heartbeat, t}, state) do
    if rem(t, 10) == 0 do
      Doro.GameState.all_entities(&Enum.member?(&1.behaviors, __MODULE__))
      |> Enum.each(fn clock -> tell_time(clock, t) end)
    end

    {:noreply, state}
  end

  defp tell_time(clock, t) do
    Doro.GameState.all_entities(fn e ->
      e.props[:location] == clock.props.location &&
        Enum.member?(e.behaviors, Doro.Behaviors.Player)
    end)
    |> Enum.each(&send_to_player(&1.id, "At the tone the time will be: #{t}"))
  end
end
