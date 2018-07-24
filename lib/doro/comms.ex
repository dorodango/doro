defmodule Doro.Comms do
  @moduledoc """
  Functions for sending output to players.
  """

  @doc """
  Send text to player.  Optional data can be used if rich data needs to be sent
  to a particular client e.g. a React web interface might be able to do something with
  a JSON representation of an entity
  """
  def send_to_player(player = %Doro.Entity{}, s, data \\ %{}) do
    payload = %{ text: s, data: data }
    Phoenix.PubSub.broadcast(Doro.PubSub, "player-session:#{player.id}", {:send, payload})
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
