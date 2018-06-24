defmodule Doro.Behaviors.Portable do
  @moduledoc """
  Allows entities to be picked up and dropped.
  """
  use Doro.Behavior
  import Doro.Comms
  alias Doro.Entity

  @verbs MapSet.new(~w(take drop))

  def responds_to?(verb, _) do
    MapSet.member?(@verbs, verb)
  end

  def handle(%{verb: "take", object: object, player: player}) do
    Doro.World.move_entity(object, player)
    send_to_player(player, "Taken.")
    send_to_others(player, "#{Entity.name(player)} takes something.")
  end

  def handle(%{verb: "drop", object: object, player: player}) do
    Doro.World.move_entity(object, player[:location])
    send_to_player(player, "Dropped.")
    send_to_others(player, "#{Entity.name(player)} drops something.")
  end
end
