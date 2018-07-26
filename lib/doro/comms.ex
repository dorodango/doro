defmodule Doro.Comms do
  @moduledoc """
  Functions for sending output to players.
  """

  @doc """
  Send information to player.

  You must include a message, but you can optionally add data (a map) if rich data
  needs to be sent for particular client e.g. a React web interface might be able
  to do something with a JSON representation of an entity. If that data is included,
  it should include a "type" field

  ## Examples

  iex> Doro.Comms.send_to_player(player, "You feel dizzy")
  iex> Doro.Comms.send_to_player(player, "You hear a sound.", {
    "type": "play_sound",
    "url": "http://environmentalsounds.com/creepy_forest.wav"
  })

  where in the 2nd example, the consumer UI could play that sound

  """
  def send_to_player(player = %Doro.Entity{}, s), do: send_to_player(player, s, %{ "type": "default"})
  def send_to_player(player = %Doro.Entity{}, s, data = %{ "type": _type } ) do
    payload = %{ text: s, data: data }
    Phoenix.PubSub.broadcast(Doro.PubSub, "player-session:#{player.id}", {:send, payload})
  end

  @doc """
  Send information to other players in the same location.

  Find all the players in the location of the input player, and send the message
  to them with `#send_to_player/2`
  """
  def send_to_others(player = %Doro.Entity{props: %{location: location}}, s) do
    Doro.World.players_in_location(location)
    |> Enum.filter(&(&1.id != player.id))
    |> Enum.each(fn player ->
      send_to_player(player, s)
    end)
  end

  @doc """
  Send information to all players in a location.

  Find all the players in the location, and send the message
  to them with `#send_to_player/2`
  """
  def send_to_location(location_id, s) do
    Doro.World.players_in_location(location_id)
    |> Enum.each(&send_to_player(&1, s))
  end

end
