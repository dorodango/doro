defmodule Doro.Behaviors.Player do
  use Doro.Behavior

  def handle(ctx = %{verb: "look", subject: player, object: object}) do
    if player.id == object.id do
      send_to_player(ctx, Doro.Context.location(ctx).props.description)

      # List entities
      Doro.World.entities_in_location(player.props.location)
      |> Enum.filter(&(&1.id != player.id))
      |> Enum.each(fn e -> send_to_player(ctx, "[#{e.id}] is here.") end)
    end

    ctx
  end

  def handle(ctx = %{verb: "halp"}) do
    send_to_player(ctx, "You are helpless.")
  end

  def handle(ctx), do: super(ctx)
end
