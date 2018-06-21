defmodule Doro.World do
  @moduledoc """
  Functions for interacting with the world state.
  """

  alias Doro.World.GameState

  def get_entity(id) do
    GameState.get_entity(id)
  end

  def entities_in_location(location) do
    GameState.get_entities(fn e -> e.props[:location] == location end)
  end

  def entities_in_locations(locations) do
    GameState.get_entities(fn e -> Enum.member?(locations, e.props[:location]) end)
  end

  def entities_with_behavior(behavior) do
    GameState.get_entities(fn e -> Enum.member?(e.behaviors, behavior) end)
  end

  def entities_in_location_with_behavior(location, behavior) do
    GameState.get_entities(fn e ->
      e.props[:location] == location && Enum.member?(e.behaviors, behavior)
    end)
  end

  @doc "Convenience function"
  def players_in_location(location) do
    entities_in_location_with_behavior(location, Doro.Behaviors.Player)
  end

  def move_entity(entity, destination_id) when is_binary(destination_id) do
    GameState.set_prop(entity.id, :location, destination_id)
  end

  def move_entity(entity, destination) do
    move_entity(entity, destination.id)
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
