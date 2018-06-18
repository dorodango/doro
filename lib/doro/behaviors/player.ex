defmodule Doro.Behaviors.Player do
  use Doro.Behavior

  def handle(ctx = %{verb: "halp"}) do
    send_to_player(ctx, "You are helpless.")
  end

  def handle(ctx = %{handled: false}) do
    send_to_player(ctx, "Huh?")
  end

  def handle(ctx), do: super(ctx)
end
