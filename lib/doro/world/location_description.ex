defmodule Doro.LocationDescription do
  alias Doro.World
  import Doro.SentenceConstruction
  import Doro.World.EntityFilters

  @moduledoc """
  Constructs a description like:

  Perfect Cellar
  You are in a dark and musty cellar.  There is are random things strewn around, including a <>, an <>,
  and a <>. You can see exits to the N, NE, and E, in addition to a ladder and a closet door.  Viper, Goose,
  and Maverick are here.
  """

  def describe(location_id, looker) do
    %{name: name, behaviors: %{Doro.Behaviors.Visible => %{description: location_description}}} =
      World.get_entity(location_id)

    location_entities = World.get_entities([visible(), in_location(location_id)])

    items =
      location_entities
      |> Enum.filter(nix(has_behavior(Doro.Behaviors.Exit)))
      |> Enum.filter(nix(has_behavior(Doro.Behaviors.Player)))

    players = location_entities |> Enum.filter(player()) |> Enum.filter(except(looker.id))
    exits = location_entities |> Enum.filter(has_behavior(Doro.Behaviors.Exit))

    [
      "#{name}\n#{location_description}",
      items_sentence(items),
      players_sentence(players),
      exits_sentence(exits)
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
  end

  defp items_sentence([]), do: nil

  @items_sentence_starts [
    "There are some things here, most notably",
    "The usual stuff is here, including",
    "You spy",
    "You see",
    "You notice",
    "You find",
    "Here you see"
  ]

  defp items_sentence(items) do
    "#{Enum.random(@items_sentence_starts)} #{indefinite_list(items)}."
  end

  @nondirectional_exits_sentence_starts [
    "Looks like the only exits are",
    "You can leave via",
    "To get out of here, you can use"
  ]

  defp exits_sentence([]), do: nil

  defp exits_sentence(exits) do
    case Enum.split_with(exits, &is_directional_exit?/1) do
      {[], nondirs} ->
        "#{Enum.random(@nondirectional_exits_sentence_starts)} #{indefinite_list(nondirs)}."

      {dirs, []} ->
        "#{directional_exits_phrase(dirs)}."

      {dirs, nondirs} ->
        "#{directional_exits_phrase(dirs)}, in addition to #{indefinite_list(nondirs)}."
    end
  end

  @directions MapSet.new(~w(n e s w))
  defp is_directional_exit?(exit), do: MapSet.member?(@directions, exit.name)

  @direction_abbrevs %{"n" => "north", "e" => "east", "s" => "south", "w" => "west"}
  @direction_order %{"n" => 1, "e" => 2, "s" => 3, "w" => 4}

  defp directional_exits_phrase([exit]) do
    "You can see an exit to the #{@direction_abbrevs[exit.name]}"
  end

  defp directional_exits_phrase(exits) do
    directions =
      comma_list(
        exits
        |> Enum.sort_by(&@direction_order[&1.name])
        |> Enum.map(&@direction_abbrevs[&1.name]),
        "and",
        & &1
      )

    "You can see exits to the #{directions}"
  end

  defp players_sentence([]), do: ""
  defp players_sentence([player]), do: "#{player.name} is here."
  defp players_sentence(players), do: "#{indefinite_list(players)} are here."
end
