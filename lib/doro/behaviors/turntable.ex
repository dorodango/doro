defmodule Doro.Behaviors.Turntable do
  use Doro.Behavior
  import Doro.Comms
  import Doro.SentenceConstruction

  import Inspector

  @spinning_message "The record is spinning at 33RPM."

  def synonyms, do: %{ "use" => ~w(play) }

  def responds_to?(verb,_) do
    ["stop","play","use"] 
    |> Enum.find(fn(r) -> r == verb end)
  end

  def handle(%{verb: "use", object: object, player: player}) do
    if (object |> is_playing?) do
       player |> send_to_player("It's already playing.")
    else
      object |> set_playing(true)
      send_to_player(player, "You hear some funky music.")
      send_to_others(player, "The room fills with funky music.")
    end
  end

  def handle(%{verb: "stop", object: object, player: player}) do
    if (!(object |> is_playing?)) do
      player |> send_to_player("It's already not playing.")
    else
      object |> set_playing(false)
      send_to_player(player, "The room goes silent")
      send_to_others(player, "The room goes silent")
    end
  end

  defp set_playing(object, playing) do
    Doro.World.set_prop(object, :playing, playing)
    update_description(object, playing)
  end

  defp is_playing?(turntable), do: turntable.props[:playing]

  defp update_description(turntable, true) do
    turntable
    |> update_description(
      "#{Doro.World.get_entity("turntable")[:description]} #{@spinning_message}"
    )
  end
  defp update_description(turntable, false) do
    turntable
    |> update_description(
      Doro.World.get_entity("turntable")[:description] |> String.replace(~r[\s*#{@spinning_message}\s*], "")
    )
  end
  defp update_description(turntable, desc) when is_binary(desc) do
    Doro.World.set_prop(turntable, :description, desc)
  end

end
