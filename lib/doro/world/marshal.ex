defmodule Doro.World.Marshal do
  require Logger

  @moduledoc """
  Functions for loading the world from JSON
  """

  @doc "Unmarshals a world from a JSON string"
  def unmarshal(json) do
    json
    |> Poison.decode!(keys: :atoms)
    |> unmarshal_world()
  end

  defp unmarshal_world(world) do
    world
    |> (fn state -> %{state | entities: unmarshal_entities(state.entities)} end).()
  end

  defp unmarshal_entities(entity_map) do
    entity_map
    |> Enum.reduce(%{}, fn {_, entity}, acc ->
      Map.put(acc, entity.id, unmarshal_entity(entity))
    end)
  end

  defp unmarshal_entity(entity) do
    entity
    |> resolve_behaviors()
    |> (&struct(Doro.Entity, &1)).()
  end

  defp resolve_behaviors(entity) do
    Map.put(
      entity,
      :behaviors,
      Enum.map(
        Map.get(entity, :behaviors, []),
        &String.to_existing_atom("Elixir.Doro.Behaviors.#{Macro.camelize(&1)}")
      )
    )
  end
end
