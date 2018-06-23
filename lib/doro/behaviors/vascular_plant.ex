defmodule Doro.Behaviors.VascularPlant do
  use Doro.Behavior
  alias Doro.Entity

  @prop :vascular_plant_hydration_level
  @default_hydration 10

  def responds_to?(verb, _) do
    verb == "water"
  end

  def handle(%{verb: "water", object: plant, player: player}) do
    plant = Doro.World.set_prop(plant, @prop, @default_hydration)
    broadcast_condition(plant)
    Doro.Comms.send_to_player(player, "You water #{Entity.name(plant)}.")
    Doro.Comms.send_to_others(player, "#{Entity.name(player)} waters #{Entity.name(plant)}.")
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
      "#{Doro.Entity.name(plant)} looks #{desc(plant[@prop])}."
    )
  end

  defp desc(level) when level > 6, do: "lush and vibrant"
  defp desc(level) when level in 4..6, do: "somewhat whithered"
  defp desc(level) when level in 1..3, do: "brown and crispy"
  defp desc(_), do: "dead"
end
