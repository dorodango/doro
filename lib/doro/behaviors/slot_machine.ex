defmodule Doro.Behaviors.SlotMachine do
  use Doro.Behavior,
    slot_machine_rewards: []

  import Doro.Comms
  import Doro.SentenceConstruction

  interact("use", %{
    object: %Doro.Entity{
      props: %{location: location_id},
      behaviors: %{Doro.Behaviors.SlotMachine => %{slot_machine_rewards: rewards}}
    },
    player: player
  }) do
    entity =
      Enum.random(rewards)
      |> Doro.Entity.create(%{location: location_id}, &generate_instance_name/1)

    Doro.World.add_entity(entity)
    send_to_player(player, "You create #{indefinite(entity)}.")
  end

  defp generate_instance_name(prototype) do
    "#{physical_adjective()} #{prototype.name}"
  end
end
