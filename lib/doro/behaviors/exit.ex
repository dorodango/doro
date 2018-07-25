defmodule Doro.Behaviors.Exit do
  use Doro.Behavior
  import Doro.Comms

  interact("exit", ~w(go), %{
    object: %{behaviors: %{Doro.Behaviors.Exit => %{destination_id: destination_id}}},
    player: player
  }) do
    send_to_others(player, "#{Doro.Entity.name(player)} exits.")
    player = Doro.World.move_entity(player, destination_id)
    Doro.Behaviors.Player.handle("look", %Doro.Context{player: player})
    send_to_others(player, "#{Doro.Entity.name(player)} is now here.")
  end
end
