defmodule Doro.World.Marshal do
  require Logger

  @moduledoc """
  Functions for loading the world from JSON
  """

  @doc "Unmarshals a world from a JSON string"
  def unmarshal(json) when is_binary(json) do
    json
    |> Poison.decode!(keys: :atoms)
    |> unmarshal()
  end

  @doc "Unmarshals a world from a JSON string"
  def unmarshal(json) when is_map(json) do
    entities =
      json
      |> Map.get(:entities)
      |> Enum.map(&unmarshal_entity/1)

    %{entities: entities}
  end

  @doc "Marshal the world to a JSON string"
  def marshal(data) do
    data
    |> Enum.map(&unresolve_behaviors/1)
  end

  defp marshal_entity(entity) do
    entity
    |> unresolve_behaviors
  end

  defp unresolve_behaviors(nil), do: nil
  defp unresolve_behaviors(entity = %{behaviors: []}), do: entity

  defp unresolve_behaviors(entity) do
    %{entity | behaviors: entity |> Map.get(:behaviors, []) |> Enum.map(&canonicalize_behavior/1)}
  end

  defp canonicalize_behavior(behavior_module) do
    behavior_module
    |> Modules.to_underscore()
  end

  defp unmarshal_entity(data) do
    data
    |> resolve_behaviors()
    |> (&Doro.Entity.preprocess_name(&1)).()
    |> (&struct(Doro.Entity, &1)).()
  end

  defp resolve_behaviors(data) do
    Map.put(
      data,
      :behaviors,
      Enum.map(
        Map.get(data, :behaviors, []),
        &String.to_existing_atom("Elixir.Doro.Behaviors.#{Macro.camelize(&1)}")
      )
    )
  end
end
