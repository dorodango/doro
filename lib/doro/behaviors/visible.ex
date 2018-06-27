defmodule Doro.Behaviors.Visible do
  use Doro.Behavior
  import Doro.Comms
  import Doro.SentenceConstruction

  def responds_to?(verb, %{player: player, object: object}) do
    verb == "look" && player != object
  end

  def handle(%{verb: "look", player: player, object: object}) do
    send_to_player(player, first_person_description(object))
    send_to_others(player, "#{definite(player)} looks at #{definite(object)} thoughtfully.")
  end

  def first_person_description(entity) do
    "#{definite(entity)} #{entity[:description]}"
  end
end
