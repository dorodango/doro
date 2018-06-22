defmodule Doro.Phenomena.Clock do
  require Logger
  import Doro.Comms

  def tick(t) do
    if rem(t, 10) == 0 do
      Doro.World.entities_with_behavior(Doro.Behaviors.Clock)
      |> Enum.each(fn clock -> tell_time(clock, t) end)
    end
  end

  defp tell_time(clock, t) do
    Doro.World.players_in_location(clock.props.location)
    |> Enum.each(&send_to_player(&1, "At the tone the time will be: #{t}"))
  end
end
