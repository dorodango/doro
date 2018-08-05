defmodule Doro.Behaviors.Turntable do
  use Doro.Behavior,
    playing: false

  import Doro.Comms

  @spinning_message "The record is spinning at 33RPM."

  interact("use", ~w(play), %{object: object, player: player}) do
    if object |> is_playing? do
      player |> send_to_player("It's already playing.")
    else
      object |> set_playing(true)

      send_to_player(player, "You hear some funky music.")
      send_to_others(player, "The room fills with funky music.")
    end
  end

  interact("stop", %{object: object, player: player}) do
    if !(object |> is_playing?) do
      player |> send_to_player("It's already not playing.")
    else
      object |> set_playing(false)
      send_to_player(player, "The room goes silent")
      send_to_others(player, "The room goes silent")
    end
  end

  defp set_playing(object, playing) do
    Doro.World.set_prop(object, :playing, playing)
  end

  defp is_playing?(turntable), do: turntable.props[:playing]

end
