defmodule Doro.Behaviors.Player do
  use Doro.Behavior
  import Doro.Comms
  import Doro.SentenceConstruction
  import Doro.World.EntityFilters
  alias Doro.World

  interact_if("look", ctx, do: is_nil(ctx.rest))

  interact("look", ~w(l), %{player: player}) do
    player
    |> send_to_player(Doro.LocationDescription.describe(player[:location], player))
  end

  interact("say", %{player: player, original_command: original_command}) do
    case Regex.run(~r/say (.*)/, original_command, capture: :all_but_first) do
      nil ->
        send_to_player(player, "No one can hear you if you have nothing to say")

      [words] ->
        what_i_said = words |> String.trim()
        send_to_player(player, "\"#{what_i_said}\"")
        send_to_others(player, "#{Doro.Entity.name(player)} says, \"#{what_i_said}\"")
    end
  end

  interact("/description", %{player: player, original_command: original_command}) do
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

  interact("/deify", %{player: player}) do
    Doro.World.add_behavior(player, Doro.Behaviors.God)
    send_to_player(player, "You feel more capable.")
  end

  interact("inventory", ~w(i inv), %{player: player}) do
    World.get_entities([in_location(player.id)])
    |> indefinite_list()
    |> (&send_to_player(player, "You are carrying #{&1}.")).()
  end

  interact("emote", %{player: player, rest: rest}) do
    case rest do
      nil ->
        send_to_player(player, "What sort of emotion do you want to show?")

      emotion ->
        send_to_player(player, "Done emoting.")
        send_to_others(player, "#{Doro.Entity.name(player)} #{emotion}")
    end
  end

  interact("help", ~w(halp), %{player: player}) do
    send_to_player(player, "You are helpless.")
  end
end
