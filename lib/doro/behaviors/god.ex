defmodule Doro.Behaviors.God do
  use Doro.Behavior
  import Doro.Comms

  def handle(ctx = %{verb: "/reload"}) do
    Doro.World.clobber_from_default()
    send_to_player(ctx, "Game state reloaded.")
  end

  def handle(ctx = %{verb: "/gistworld"}) do
    Regex.run(~r/\/gistworld (\w+)/, ctx.original_command, capture: :all_but_first)
    |> List.first()
    |> Doro.World.clobber_from_gist()

    send_to_player(ctx, "Game state reloaded from gist.")
  end

  def handle(ctx), do: super(ctx)
end
