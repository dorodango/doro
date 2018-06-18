defmodule Doro.Behaviors.Visible do
  use Doro.Behavior

  def handle(ctx = %{verb: "look"}) do
    send_to_player(ctx, ctx.object.props.description)
  end

  def handle(ctx = %{verb: verb, object: object}) do
    send_to_player(ctx, "You can't [#{verb}] a [#{object.id}]!")
  end

  def handle(ctx), do: super(ctx)
end
