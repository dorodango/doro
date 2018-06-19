defmodule Doro.Behaviors.Visible do
  use Doro.Behavior

  def handle(ctx = %{verb: "look"}) do
    if ctx.subject != ctx.object do
      send_to_player(ctx, "[#{ctx.object.id}] #{ctx.object.props.description}")
      send_to_others(ctx, "[#{ctx.subject.id}] looks at [#{ctx.object.id}] thoughtfully.")
    end

    ctx
  end

  def handle(ctx), do: super(ctx)
end
