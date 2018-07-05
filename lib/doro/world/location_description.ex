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
    location = World.get_entity(location_id)
    location_entities = World.get_entities([visible(), in_location(location.id)])

    items =
      location_entities
      |> Enum.filter(nix(has_behavior(Doro.Behaviors.Exit)))
      |> Enum.filter(nix(has_behavior(Doro.Behaviors.Player)))

    players = location_entities |> Enum.filter(player()) |> Enum.filter(except(looker.id))
    exits = location_entities |> Enum.filter(has_behavior(Doro.Behaviors.Exit))

    [
      "#{location.name}\n#{location[:description]}",
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

  defp exits_sentence([]), do: nil

  defp exits_sentence([exit | []]) do
    case is_directional_exit?(exit) do
      true -> "There is an exit to the #{exit.name}."
      _ -> "You can leave via #{indefinite(exit)}."
    end
  end

  @nondirectional_exits_sentence_starts [
    "Looks like the only exits are",
    "You can leave via",
    "To get out of here, you can use"
  ]

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

  defp directional_exits_phrase([exit]), do: "You can see an exit to the #{exit.name}"
  defp directional_exits_phrase(exits), do: "You can see exits to the #{proper_list(exits)}"

  defp players_sentence([]), do: ""
  defp players_sentence([player]), do: "#{player.name} is here."
  defp players_sentence(players), do: "#{indefinite_list(players)} are here."
end
