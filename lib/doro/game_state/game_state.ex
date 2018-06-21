defmodule Doro.GameState do
  use Agent

  def start_link() do
    Agent.start_link(&read_debug_world/0, name: __MODULE__)
  end

  @doc "For use during development.  Reloads the game state from the filesystem."
  def reload do
    Agent.update(__MODULE__, fn _ -> read_debug_world() end)
  end

  @doc """
  For use during development.  Reloads the game state from a github gist.

  This will load the content of the first file in the gist.  It should be a JSON file
  in the format of game_state.json.

  There is NO ERROR HANDLING.
  """
  def load_from_gist(gist_id) do
    Agent.update(__MODULE__, fn _ -> Doro.GameState.Gist.load_gist(gist_id) end)
  end

  @doc "Gets an entity by id"
  def get_entity(nil), do: nil

  def get_entity(id) do
    Agent.get(__MODULE__, fn world -> world.entities[id] end)
  end

  def entities_in_location(location) do
    Agent.get(__MODULE__, fn world ->
      world.entities
      |> Map.values()
      |> entities_in_location(location)
    end)
  end

  def all_entities(filter \\ & &1) do
    Agent.get(__MODULE__, fn world ->
      world.entities
      |> Map.values()
      |> Enum.filter(filter)
    end)
  end

  def players_in_location(location) do
    entities_in_location(location)
    |> entities_with_behavior(Doro.Behaviors.Player)
  end

  defp entities_with_behavior(entities, behavior) do
    entities
    |> Enum.filter(fn e -> Enum.member?(e.behaviors, behavior) end)
  end

  defp entities_in_location(entities, location) do
    entities
    |> Enum.filter(fn e -> e.props[:location] == location end)
  end

  defp read_debug_world do
    Path.join(:code.priv_dir(:doro), "game_state.json")
    |> File.read!()
    |> Doro.GameState.Marshal.unmarshal()
  end
end
