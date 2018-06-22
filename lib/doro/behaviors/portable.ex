defmodule Doro.Behaviors.Portable do
  @moduledoc """
  Allows entities to be picked up and dropped.
  """
  use Doro.Behavior
  import Doro.Comms
  alias Doro.Entity

  @verbs MapSet.new(~w(take drop))

  def responds_to?(verb, ctx) do
    MapSet.member?(@verbs, verb) && ctx.object
  end

  def handle(%{verb: "take", object: object, player: player}) do
    Doro.World.move_entity(object, player)
    send_to_player(player, "Taken.")
    send_to_others(player, "#{Entity.name(player)} greedily takes the #{Entity.name(object)}")
  end

  def handle(%{verb: "drop", object: object, player: player}) do
    Doro.World.move_entity(object, player.props.location)
    send_to_player(player, "Dropped.")
    send_to_others(player, "#{Entity.name(player)} dropped something.")
  end

  def handle(ctx), do: super(ctx)
end
