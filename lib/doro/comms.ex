defmodule Doro.Comms do
  @moduledoc """
  Functions for sending output to players.
  """
  def send_to_player(player = %Doro.Entity{}, s) do
    Phoenix.PubSub.broadcast(Doro.PubSub, "player-session:#{player.id}", {:send, s})
  end

  def send_to_others(player = %Doro.Entity{props: %{location: location}}, s) do
    Doro.World.players_in_location(location)
    |> Enum.filter(&(&1.id != player.id))
    |> Enum.each(fn player ->
      send_to_player(player, s)
    end)
  end

  def send_to_location(location_id, s) do
    Doro.World.players_in_location(location_id)
    |> Enum.each(&send_to_player(&1, s))
  end
end
