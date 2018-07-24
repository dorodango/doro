defmodule Doro.Behaviors.God do
  use Doro.Behavior
  import Doro.Comms
  import Doro.World.EntityFilters

  interact("/reload", %{player: player}) do
    Doro.World.load()
    send_to_player(player, "Game state reloaded.")
  end

  interact("/loadworld", %{player: player, rest: world_source}) do
    Doro.World.load(world_source)
    send_to_player(player, "Game state reloaded from #{world_source}.")
  end

  interact("/entdump", %{player: player}) do
    Doro.World.get_entities([in_location(player[:location])])
    |> Enum.chunk_every(5)
    |> Enum.each(fn chunk ->
      send_to_player(player, "```\n#{Poison.encode!(chunk, pretty: true)}\n```")
    end)
  end
end
