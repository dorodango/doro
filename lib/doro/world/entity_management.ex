defmodule Doro.World.EntityManagement do
  alias Doro.Entity
  alias Doro.World.GameState

  @moduledoc """
  Deals with adding, removing and modifying entities.
  """

  @doc "Resets the game state to the new state"
  def reset(entities) do
    # reset/kill processes?
    GameState.clear()
    add_entities(entities)
  end

  @doc "Adds a single entity to the existing game state"
  def add_entity(%Entity{behaviors: behaviors} = entity) do
    tagged_behaviors =
      behaviors
      |> Enum.map(fn {k, v} -> {k, Map.put(v, :own, true)} end)
      |> Enum.into(%{})

    rolled_up_behaviors =
      entity.proto
      |> Doro.World.get_entity()
      |> roll_up_behaviors()
      |> Enum.map(fn {k, v} -> {k, Map.put(v, :own, false)} end)
      |> Enum.into(%{})
      |> Map.merge(tagged_behaviors)

    GameState.add_entity(%{entity | behaviors: rolled_up_behaviors})
  end

  def add_entities(new_entities) when is_list(new_entities) do
    # Add prototypes first, then add entities
    {protos, entities} = Enum.split_with(new_entities, &is_proto?/1)
    Enum.map(protos, &add_entity/1) ++ Enum.map(entities, &add_entity/1)
  end

  def update_entity(entity) do
    GameState.add_entity(entity)
  end

  defp is_proto?(%Entity{id: id}), do: match?("_" <> _, id)

  defp roll_up_behaviors(nil), do: %{}

  defp roll_up_behaviors(entity = %Entity{behaviors: my_behaviors}) do
    Map.merge(roll_up_behaviors(Doro.World.get_entity(entity.proto)), my_behaviors)
  end
end
