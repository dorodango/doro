defmodule Doro.World do
  @moduledoc """
  Functions for interacting with the world state.
  """

  require Logger

  alias Doro.World.GameState
  alias Doro.Entity

  import Doro.World.EntityFilters

  defdelegate get_entity(id), to: GameState
  defdelegate add_entity(entity), to: GameState

  def get_entities(filters \\ []) do
    GameState.get_entities(fn e ->
      Enum.all?(filters, & &1.(e))
    end)
  end

  def players_in_location(location_id) do
    get_entities([
      in_location(location_id),
      player()
    ])
  end

  def move_entity(entity, destination = %Entity{}), do: move_entity(entity, destination.id)

  def move_entity(entity, destination_id) when is_binary(destination_id) do
    set_prop(entity, :location, destination_id)
  end

  def set_prop(entity, key, value) do
    GameState.set_prop(entity.id, key, value)
    put_in(entity, [key], value)
  end

  def add_behavior(entity, behavior) do
    case Entity.has_behavior?(entity, behavior) do
      false ->
        GameState.add_entity(%{entity | behaviors: [behavior | entity.behaviors]})

      _ ->
        entity
    end
  end

  @doc "Find or create by name"
  def find_or_create_player(name, location_id) do
    case get_entities([player(), named(name)]) do
      [] ->
        entity = Entity.create("_player", %{location: location_id}, fn _ -> name end)
        GameState.add_entity(entity)

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
