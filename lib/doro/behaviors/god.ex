defmodule Doro.Behaviors.God do
  use Doro.Behavior
  import Doro.Comms
  import Doro.World.EntityFilters

  @verbs MapSet.new(~w(/reload /gistworld /entdump))

  def responds_to?(verb, _) do
    MapSet.member?(@verbs, verb)
  end

  def handle(%{verb: "/reload", player: player}) do
    Doro.World.load_default()
    send_to_player(player, "Game state reloaded.")
  end

  def handle(ctx = %{verb: "/gistworld", player: player}) do
    Regex.run(~r/\/gistworld (\w+)/, ctx.original_command, capture: :all_but_first)
    |> List.first()
    |> Doro.World.load_from_gist()

    send_to_player(player, "Game state reloaded from gist.")
  end

  def handle(%{verb: "/entdump", player: player}) do
    Doro.World.get_entities([in_location(player[:location])])
    |> Enum.chunk_every(5)
    |> Enum.each(fn chunk ->
      send_to_player(player, "```\n#{Poison.encode!(chunk, pretty: true)}\n```")
    end)
  end

  def handle(ctx), do: super(ctx)
end
