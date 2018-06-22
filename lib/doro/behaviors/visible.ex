defmodule Doro.Behaviors.Visible do
  use Doro.Behavior
  import Doro.Comms

  @verbs MapSet.new(~w(look))

  def responds_to?(verb, ctx) do
    MapSet.member?(@verbs, verb) && ctx.object
  end

  def handle(ctx = %{verb: "look", player: player}) do
    send_to_player(player, "[#{ctx.object.id}] #{ctx.object.props.description}")
    send_to_others(player, "[#{ctx.player.id}] looks at [#{ctx.object.id}] thoughtfully.")
    ctx
  end

  def handle(ctx), do: super(ctx)
end
