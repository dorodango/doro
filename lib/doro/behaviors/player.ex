defmodule Doro.Behaviors.Player do
  use Doro.Behavior
  import Doro.Comms
  alias Doro.World

  @verbs MapSet.new(~w(look halp))

  def responds_to?("look", ctx) do
    ctx.original_command == "look"
  end

  def responds_to?(verb, _) do
    MapSet.member?(@verbs, verb)
  end

  def handle(ctx = %{verb: "look", player: player}) do
    send_to_player(player, World.get_entity(player.props.location).props.description)

    # List entities
    Doro.World.entities_in_location(player.props.location)
    |> Enum.filter(&(&1.id != player.id))
    |> Enum.each(fn e -> send_to_player(player, "[#{e.id}] is here.") end)

    ctx
  end

  def handle(%{verb: "halp", player: player}) do
    send_to_player(player, "You are helpless.")
  end

  def handle(ctx), do: super(ctx)
end
