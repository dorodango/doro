defmodule Doro.Behaviors.God do
  use Doro.Behavior

  def handle(ctx = %{verb: "/reload"}) do
    Doro.GameState.reload()
    send_to_player(ctx, "Game state reloaded.")
  end

  def handle(ctx), do: super(ctx)
end
