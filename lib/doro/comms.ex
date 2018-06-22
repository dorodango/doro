defmodule Doro.Comms do
  @moduledoc """
  Functions for sending output to players.
  """
  def send_to_player(ctx, s) when is_map(ctx) do
    send_to_player(ctx.subject.id, s)
    %{ctx | handled: true}
  end

  def send_to_player(player_id, s) when is_binary(player_id) do
    Doro.Engine.send_to_player(player_id, s)
  end

  def send_to_others(ctx = %{subject: %{props: %{location: location}}}, s) do
    Doro.World.players_in_location(location)
    |> Enum.filter(&(&1.id != ctx.subject.id))
    |> Enum.each(fn player ->
      Doro.Engine.send_to_player(player.id, s)
    end)

    %{ctx | handled: true}
  end
end
