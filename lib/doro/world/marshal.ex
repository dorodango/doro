defmodule Doro.World.Marshal do
  require Logger

  @moduledoc """
  Functions for loading the world from JSON
  """

  @doc "Unmarshals a world from a JSON string"
  def unmarshal(json) do
    entities =
      json
      |> Poison.decode!(keys: :atoms)
      |> Map.get(:entities)
      |> Enum.map(&unmarshal_entity/1)
      |> fixup_pointers()
      |> Enum.reduce(%{}, fn entity, acc -> Map.put(acc, entity.id, entity) end)

    %{entities: entities}
  end

  defp unmarshal_entity(data) do
    data
    |> resolve_behaviors()
    |> preprocess_name()
    |> (&struct(Doro.Entity, &1)).()
  end

  defp preprocess_name(data) do
    name = Map.get(data, :name, data.id) |> String.downcase()

    Map.put(
      data,
      :name_tokens,
      [name | String.split(name)] |> MapSet.new()
    )
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

  defp fixup_pointers(entities) do
    Enum.split_with(entities, &is_nil(&1.proto))
    |> resolve_prototypes()
  end

  defp resolve_prototypes({resolved, []}), do: resolved

  defp resolve_prototypes({resolved, unresolved}) do
    {to_resolve, unresolved} =
      Enum.split_with(unresolved, fn e ->
        Enum.any?(resolved, &(&1.id == e.proto))
      end)

    resolved =
      Enum.reduce(to_resolve, resolved, fn e, acc ->
        [%{e | proto: Enum.find(resolved, &(&1.id == e.proto))} | acc]
      end)

    resolve_prototypes({resolved, unresolved})
  end
end
