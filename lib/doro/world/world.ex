defmodule Doro.World do
  @moduledoc """
  Functions for interacting with the world state.
  """

  require Logger

  alias Doro.World.GameState
  alias Doro.Entity

  def get_entity(id) do
    GameState.get_entity(id)
  end

  def insert_entity(entity = %Doro.Entity{}) do
    GameState.add_entity(entity)
    entity
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
    GameState.get_entities(&(&1[:location] == location_id && Entity.has_behavior?(&1, behavior)))
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

  @doc "Find or create by name"
  def find_or_create_player(name, location_id) do
    case GameState.get_entities(fn e ->
           Entity.has_behavior?(e, Doro.Behaviors.Player) && Entity.named?(e, name)
         end) do
      [] ->
        entity = Entity.create("_player", %{location: location_id}, fn _ -> name end)
        GameState.add_entity(entity)
        entity

      # create player
      [player] ->
        player
    end
  end

  @doc "Loads a world file"
  def load(s) do
    s
    |> Doro.World.Loader.load()
    |> clobber()
  end

  @doc "Loads from gist"
  def load_from_gist(gist_id) do
    Logger.info("Loading world file from gist: #{gist_id}")

    gist_id
    |> Doro.Utils.load_gist()
    |> load()
  end

  @doc "Loads a world from game_state.json"
  def load_default() do
    Path.join(:code.priv_dir(:doro), "world.json")
    |> File.read!()
    |> load()
  end

  @doc "Replaces the current game state"
  def clobber(s) when is_binary(s) do
    s
    |> Doro.World.Marshal.unmarshal()
    |> clobber()
  end

  def clobber(new_state) when is_map(new_state) do
    GameState.set(new_state)
  end
end
