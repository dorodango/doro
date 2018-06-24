defmodule Doro.World do
  @moduledoc """
  Functions for interacting with the world state.
  """

  alias Doro.World.GameState
  alias Doro.Entity

  def get_entity(id) do
    GameState.get_entity(id)
  end

  def insert_entity(entity = %Doro.Entity{}) do
    GameState.add_entity(entity)
  end

  @doc """
  Finds named entities in specificied locations.
  """
  @spec get_named_entities_in_locations(String.t(), [String.t()]) :: [%Doro.Entity{}]
  def get_named_entities_in_locations(nil, _), do: []

  def get_named_entities_in_locations(name, location_ids) do
    locations_set = MapSet.new(location_ids)

    GameState.get_entities(fn e ->
      MapSet.member?(locations_set, e[:location]) && Doro.Entity.named?(e, name)
    end)
  end

  def entities_in_location(location_id) do
    GameState.get_entities(fn e -> e[:location] == location_id end)
  end

  def entities_in_locations(location_ids) do
    GameState.get_entities(fn e -> Enum.member?(location_ids, e[:location]) end)
  end

  def entities_with_behavior(behavior) do
    GameState.get_entities(fn e -> Enum.member?(Entity.behaviors(e), behavior) end)
  end

  def entities_in_location_with_behavior(location_id, behavior) do
    GameState.get_entities(fn e ->
      e[:location] == location_id && Enum.member?(Entity.behaviors(e), behavior)
    end)
  end

  @doc "Convenience function"
  def players_in_location(location_id) do
    entities_in_location_with_behavior(location_id, Doro.Behaviors.Player)
  end

  def move_entity(entity, destination_id) when is_binary(destination_id) do
    set_prop(entity, :location, destination_id)
  end

  def move_entity(entity, destination) do
    move_entity(entity, destination.id)
  end

  def set_prop(entity, key, value) do
    GameState.set_prop(entity.id, key, value)
    put_in(entity, [key], value)
  end

  @doc "Clobbers the current state of the world with this new state"
  def clobber(new_state) do
    GameState.set(new_state)
  end

  @doc "Loads a world from a gist"
  def clobber_from_gist(gist_id) do
    "https://api.github.com/gists/#{gist_id}"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Poison.decode!(keys: :atoms)
    |> Map.get(:files)
    |> Map.values()
    |> List.first()
    |> Map.get(:raw_url)
    |> clobber_from_url()
  end

  @doc "Loads a world from a document located at <url>"
  def clobber_from_url(url) do
    url
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> clobber_from_string()
  end

  @doc "Loads a world from a JSON string"
  def clobber_from_string(s) do
    s
    |> Doro.World.Marshal.unmarshal()
    |> clobber()
  end

  @doc "Loads a world from game_state.json"
  def clobber_from_default() do
    Path.join(:code.priv_dir(:doro), "game_state.json")
    |> File.read!()
    |> clobber_from_string()
  end
end
