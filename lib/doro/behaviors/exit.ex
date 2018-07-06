defmodule Doro.Behaviors.Exit do
  use Doro.Behavior
  import Doro.Comms

  interact("exit", ~w(go), %{object: object, player: player}) do
    send_to_others(player, "#{Doro.Entity.name(player)} exits.")
    player = Doro.World.move_entity(player, object[:destination_id])
    Doro.Behaviors.Player.handle("look", %Doro.Context{player: player})
    send_to_others(player, "#{Doro.Entity.name(player)} is now here.")
  end
end
