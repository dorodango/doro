defmodule Doro.Behaviors.Visible do
  use Doro.Behavior,
    description: "is an entity"

  import Doro.Comms
  import Doro.SentenceConstruction

  interact_if("look", %{player: player, object: object, rest: rest}) do
    player != object || Doro.Entity.named?(player, rest)
  end

  interact("look", ~w(l), %Doro.Context{player: player, object: object}) do
    send_to_player(player, first_person_description(object))
    send_to_others(player, "#{definite(player)} looks at #{definite(object)} thoughtfully.")
  end

  def first_person_description(
        %Doro.Entity{
          behaviors: %{Doro.Behaviors.Visible => %{description: description}}
        } = entity
      ) do
    "#{definite(entity)} #{description}"
  end
end
