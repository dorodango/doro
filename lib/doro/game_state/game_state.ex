defmodule Doro.GameState do
  use Agent

  def start_link() do
    Agent.start_link(&read_debug_world/0, name: __MODULE__)
  end

  @doc "For use during development.  Reloads the game state from the filesystem."
  def reload do
    Agent.update(__MODULE__, fn _ -> read_debug_world() end)
  end

  @doc "Gets an entity by id"
  def get_entity(nil), do: nil

  def get_entity(id) do
    Agent.get(__MODULE__, fn world -> world.entities[id] end)
  end

  defp read_debug_world do
    Path.join(:code.priv_dir(:doro), "game_state.json")
    |> File.read!()
    |> Doro.GameState.Marshal.unmarshal()
  end
end
