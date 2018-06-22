defmodule Doro.Behaviors.Visible do
  use Doro.Behavior
  import Doro.Comms
  alias Doro.Entity

  @verbs MapSet.new(~w(look))

  def responds_to?(verb, ctx) do
    MapSet.member?(@verbs, verb) && ctx.object
  end

  def handle(%{verb: "look", player: player, object: object}) do
    send_to_player(player, "#{Entity.name(object)} #{object.props.description}")
    send_to_others(player, "#{Entity.name(player)} looks at #{Entity.name(object)} thoughtfully.")
  end
end
