defmodule Doro.Behaviors.Clock do
  @moduledoc """
  Placeholder Clock behavior
  """
  use Doro.Behavior
  import Doro.Comms

  # Phenomenon Callbacks
  def tick(t) do
    if rem(t, 60) == 0 do
      Doro.World.entities_with_behavior(__MODULE__)
      |> Enum.each(fn clock -> tell_time(clock, t) end)
    end
  end

  defp tell_time(clock, t) do
    Doro.World.players_in_location(clock.props.location)
    |> Enum.each(&send_to_player(&1, "At the tone the time will be: #{t}"))
  end
end
