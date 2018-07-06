defmodule Doro.Behaviors.Portable do
  @moduledoc """
  Allows entities to be picked up and dropped.
  """
  use Doro.Behavior
  import Doro.Comms
  alias Doro.Entity

  interact_if "take", %Doro.Context{player: player, object: object} do
    object[:location] != player.id
  end

  interact("take", %{object: object, player: player}) do
    Doro.World.move_entity(object, player)
    send_to_player(player, "Taken.")
    send_to_others(player, "#{Entity.name(player)} takes something.")
  end

  interact_if("drop", %Doro.Context{player: player, object: object}) do
    object[:location] == player.id
  end

  interact("drop", %{object: object, player: player}) do
    Doro.World.move_entity(object, player[:location])
    send_to_player(player, "Dropped.")
    send_to_others(player, "#{Entity.name(player)} drops something.")
  end
end
