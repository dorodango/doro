defmodule Doro.Behaviors.VascularPlant do
  use Doro.Behavior
  alias Doro.Entity
  import Doro.SentenceConstruction

  @prop :vascular_plant_hydration_level
  @default_hydration 10

  def responds_to?(verb, _) do
    verb == "water"
  end

  def handle(%{verb: "water", object: plant, player: player}) do
    plant = Doro.World.set_prop(plant, @prop, @default_hydration)
    Doro.Comms.send_to_player(player, "You water #{definite(plant)}.")
    Doro.Comms.send_to_others(player, "#{definite(player)} waters #{definite(plant)}.")
    broadcast_condition(plant)
  end

  # Phenomenon
  def tick(t) do
    if rem(t, 10) == 0 do
      Doro.World.entities_with_behavior(__MODULE__)
      |> Enum.each(fn plant -> dessicate(plant) end)
    end
  end

  defp dessicate(plant) do
    plant = Doro.World.set_prop(plant, @prop, (plant[@prop] || @default_hydration) - 1)
    if(desc(plant[@prop]) != desc(plant[@prop] + 1), do: broadcast_condition(plant))
  end

  defp broadcast_condition(plant) do
    Doro.Comms.send_to_location(
      plant[:location],
      "#{definite(plant)} looks #{desc(plant[@prop])}."
    )
  end

  defp desc(level) when level > 6, do: "lush and vibrant"
  defp desc(level) when level in 4..6, do: "somewhat whithered"
  defp desc(level) when level in 1..3, do: "brown and crispy"
  defp desc(_), do: "dead"
end
