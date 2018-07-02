defmodule Doro.Behaviors.Exit do
  use Doro.Behavior
  import Doro.Comms
  alias Doro.Entity

  def synonyms do
    %{
      "exit" => ~w(go)
    }
  end

  def responds_to?(verb, _) do
    verb == "exit"
  end

  def handle(%{verb: "exit", object: object, player: player}) do
    send_to_others(player, "#{Entity.name(player)} exits.")
    player = Doro.World.move_entity(player, object[:destination_id])
    Doro.Behaviors.Player.handle(%{verb: "look", player: player})
    send_to_others(player, "#{Entity.name(player)} is now here.")
  end
end
