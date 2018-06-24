defmodule Doro.Behaviors.Exit do
  use Doro.Behavior
  import Doro.Comms
  alias Doro.Entity

  def responds_to?(verb, _) do
    verb == "exit"
  end

  def handle(%{verb: "exit", object: object, player: player}) do
    send_to_player(player, "You exit.")
    send_to_others(player, "#{Entity.name(player)} exits.")

    player = Doro.World.move_entity(player, object[:destination_id])

    send_to_others(player, "#{Entity.name(player)} is now here.")
  end
end
