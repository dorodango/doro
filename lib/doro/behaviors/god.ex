defmodule Doro.Behaviors.God do
  use Doro.Behavior
  import Doro.Comms
  import Doro.World.EntityFilters
  import Doro.SentenceConstruction

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

  interact_if("/edit", %{player: player, rest: rest}) do
    found_entity = Doro.World.get_entities([in_location(player[:location]), named(rest)])
    |> Enum.at(0)
    rest_present = (rest != nil) && (String.length(rest |> String.trim()) > 0)
    rest_present && found_entity
  end

  interact("/edit", %{player: player, rest: name}) do
    entity = Doro.World.get_entities([in_location(player[:location]), named(name)]) |> Enum.at(0)
    send_to_player(player,
      "You concentrate on #{definite(entity)}.  Nothing happens and you feel silly.",
      %{
        "type": "open_entity_editor",
        "entity": entity
      }
    )
  end
end
