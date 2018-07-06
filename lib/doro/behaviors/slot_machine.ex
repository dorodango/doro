defmodule Doro.Behaviors.SlotMachine do
  use Doro.Behavior
  import Doro.Comms
  import Doro.SentenceConstruction

  interact("use", %{object: object, player: player}) do
    entity =
      Enum.random(object[:slot_machine_rewards])
      |> Doro.Entity.create(%{location: object[:location]}, &generate_instance_name/1)

    Doro.World.add_entity(entity)
    send_to_player(player, "You create #{indefinite(entity)}.")
  end

  defp generate_instance_name(prototype) do
    "#{physical_adjective()} #{prototype.name}"
  end
end
