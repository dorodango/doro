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
    found_entity = find_entity_in_location_or_location(player, rest)
    rest_present = (rest != nil) && (String.length(rest |> String.trim()) > 0)
    rest_present && found_entity
  end

  interact("/edit", %{player: player, rest: name}) do
    entity = find_entity_in_location_or_location(player, name)
    send_to_player(player,
      "You concentrate on #{definite(entity)}.  Nothing happens and you feel silly.",
      %{
        "type": "open_entity_editor",
        "entity": entity |> Doro.World.Marshal.marshal
      }
    )
  end

  defp find_entity_in_location_or_location(player, rest) do
    found_entity = Doro.World.get_entities([in_location(player[:location]), named(rest)])
    |> Enum.at(0)
    # try location if we couldn't find the thing in the location
    case found_entity do
      nil ->
        location = Doro.World.get_entity(player[:location])
        case location |> named(rest).() do
          false -> nil
          _ -> location
        end
      _ -> found_entity
    end
  end
end
