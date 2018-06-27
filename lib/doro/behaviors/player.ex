defmodule Doro.Behaviors.Player do
  use Doro.Behavior
  import Doro.Comms
  import Doro.SentenceConstruction
  alias Doro.World

  @verbs MapSet.new(~w(look help inventory emote /description say))

  def synonyms do
    %{
      "help" => ~w(h halp),
      "inventory" => ~w(inv i),
      "look" => ~w(l)
    }
  end

  def responds_to?("look", ctx) do
    is_nil(ctx.rest)
  end

  def responds_to?(verb, _) do
    MapSet.member?(@verbs, verb)
  end

  def handle(%{verb: "look", player: player}) do
    room_desc = World.get_entity(player[:location])[:description]

    output =
      Doro.World.entities_in_location(player[:location])
      |> Enum.filter(&(&1.id != player.id))
      |> indefinite_list()
      |> (&"#{room_desc}\nAlso here is #{&1}.").()

    send_to_player(player, output)
  end

  def handle(%{verb: "say", player: player, original_command: original_command}) do
    case Regex.run(~r/say (.*)/, original_command, capture: :all_but_first) do
      nil ->
        send_to_player(player, "No one can hear you if you have nothing to say")

      [words] ->
        what_i_said = words |> String.trim()
        send_to_player(player, "\"#{what_i_said}\"")
        send_to_others(player, "#{Doro.Entity.name(player)} says, \"#{what_i_said}\"")
    end
  end

  def handle(%{verb: "/description", player: player, original_command: original_command}) do
    description =
      Regex.run(~r/\/description (.*)/, original_command, capture: :all_but_first)
      |> List.first()
      |> String.trim()

    player = Doro.World.set_prop(player, :description, description)

    send_to_player(
      player,
      "Set. This is what others will see: " <>
        Doro.Behaviors.Visible.first_person_description(player)
    )
  end

  def handle(%{verb: "inventory", player: player}) do
    Doro.World.entities_in_location(player.id)
    |> Enum.each(fn e -> send_to_player(player, "You are carrying #{indefinite(e)}.") end)
  end

  def handle(ctx = %{verb: "emote", player: player}) do
    case Regex.run(~r/emote (.*)/, ctx.original_command, capture: :all_but_first) do
      nil ->
        send_to_player(player, "What sort of emotion do you want to show?")

      [emotion] ->
        send_to_player(player, "Done emoting.")
        send_to_others(player, "#{Doro.Entity.name(player)} #{emotion}")
    end
  end

  def handle(%{verb: "help", player: player}) do
    send_to_player(player, "You are helpless.")
  end
end
