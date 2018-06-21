defmodule Doro.World.GameState do
  use Agent

  def start_link() do
    Agent.start_link(&read_debug_world/0, name: __MODULE__)
  end

  def set(new_state) do
    Agent.update(__MODULE__, fn _ -> new_state end)
  end

  def get_entity(nil), do: nil

  def get_entity(id) do
    Agent.get(__MODULE__, fn world -> world.entities[id] end)
  end

  def get_entities(filter \\ & &1) do
    Agent.get(__MODULE__, fn world ->
      world.entities
      |> Map.values()
      |> Enum.filter(filter)
    end)
  end

  defp read_debug_world do
    Path.join(:code.priv_dir(:doro), "game_state.json")
    |> File.read!()
    |> Doro.World.Marshal.unmarshal()
  end
end
