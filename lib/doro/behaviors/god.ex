defmodule Doro.Behaviors.God do
  use Doro.Behavior
  import Doro.Comms
  import Doro.World.EntityFilters

  interact("/reload", %{player: player}) do
    Doro.World.load_default()
    send_to_player(player, "Game state reloaded.")
  end

  interact("/gistworld", %{player: player, original_command: original_command}) do
    Regex.run(~r/\/gistworld (\w+)/, original_command, capture: :all_but_first)
    |> List.first()
    |> Doro.World.load_from_gist()

    send_to_player(player, "Game state reloaded from gist.")
  end

  interact("/entdump", %{player: player}) do
    Doro.World.get_entities([in_location(player[:location])])
    |> Enum.chunk_every(5)
    |> Enum.each(fn chunk ->
      send_to_player(player, "```\n#{Poison.encode!(chunk, pretty: true)}\n```")
    end)
  end
end
