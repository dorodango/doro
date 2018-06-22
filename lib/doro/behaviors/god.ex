defmodule Doro.Behaviors.God do
  use Doro.Behavior
  import Doro.Comms

  @verbs MapSet.new(~w(/reload /gistworld))

  def responds_to?(verb, _) do
    MapSet.member?(@verbs, verb)
  end

  def handle(%{verb: "/reload", player: player}) do
    Doro.World.clobber_from_default()
    send_to_player(player, "Game state reloaded.")
  end

  def handle(ctx = %{verb: "/gistworld", player: player}) do
    Regex.run(~r/\/gistworld (\w+)/, ctx.original_command, capture: :all_but_first)
    |> List.first()
    |> Doro.World.clobber_from_gist()

    send_to_player(player, "Game state reloaded from gist.")
  end

  def handle(ctx), do: super(ctx)
end
