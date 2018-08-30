defmodule Doro.World.Marshal do
  require Logger

  import MapHelpers

  alias Doro.Entity

  @moduledoc """
  Functions for loading the world from JSON
  """

  @doc "Marshal the world (or an entity) so it's ready for JSON stringification"
  def marshal(entity = %Entity{}), do: entity |> unresolve_behaviors
  def marshal(data), do: data |> Enum.map(&marshal/1)

  @doc "convert Map to an %Entity"
  def unmarshal_entity(data) do
    data
    |> resolve_behaviors()
    |> atomize_props_keys()
    |> (&Doro.Entity.preprocess_name(&1)).()
    |> (&struct(Doro.Entity, &1)).()
  end


  defp unpack_behavior(nil), do: nil
  defp unpack_behavior(behavior) do
    behavior |> elem(1)
  end

  defp unresolve_behaviors(nil), do: nil
  defp unresolve_behaviors(entity) do
    marshalled_behaviors =
      entity
      |> Doro.Entity.own_behaviors()
      |> Enum.map( &unpack_behavior/1 )

    %{entity | behaviors: marshalled_behaviors}
  end

  defp atomize_props_keys(data) do
    Map.put(
      data,
      :props,
      Map.get(data, :props, %{}) |> atomize_keys
    )
  end

  defp resolve_behaviors(data) do
    Map.put(
      data,
      :behaviors,
      Map.get(data, :behaviors, [])
      |> Enum.map(&resolve_behavior/1)
      |> Enum.filter(& &1)
      |> Enum.into(%{})
    )
  end

  defp resolve_behavior(%{"type" => key} = props), do: resolve_behavior(props |> atomize_keys)

  defp resolve_behavior(%{type: key} = props) do
    {behavior, data} = resolve_behavior(key)
    {behavior, Map.merge(data, props)}
  end

  defp resolve_behavior(key) when is_binary(key), do: resolve_behavior(String.to_atom(key))

  defp resolve_behavior(key) when is_atom(key) do
    case Enum.find(Doro.Behavior.all_behaviors(), &(&1.key() == key)) do
      nil -> nil
      behavior -> {behavior, struct(behavior)}
    end
  end
end
