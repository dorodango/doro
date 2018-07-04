defmodule Doro.World.EntityFilters do
  def has_behavior(behavior), do: &Doro.Entity.has_behavior?(&1, behavior)
  def in_location(location_id), do: &(&1[:location] == location_id)

  def in_locations(location_ids) do
    locations_set = MapSet.new(location_ids)
    &MapSet.member?(locations_set, &1[:location])
  end

  def visible(), do: has_behavior(Doro.Behaviors.Visible)
  def player(), do: has_behavior(Doro.Behaviors.Player)
  def except(entity_id), do: &(&1.id != entity_id)

  def named(nil), do: fn _ -> false end
  def named(name), do: &Doro.Entity.named?(&1, name)
end
