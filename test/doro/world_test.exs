defmodule Doro.WorldTest do
  use ExUnit.Case, async: true

  alias Doro.World

  setup do
    %{
      entities: %{
        office: %{id: "office"},
        basement: %{id: "basement"},
        player12: %{id: "player12", behaviors: ["player"], props: %{location: "office"}},
        player34: %{id: "player34", behaviors: ["player"], props: %{location: "basement"}},
        plant: %{id: "plant", behaviors: ["visible"], props: %{location: "office"}}
      }
    }
    |> Poison.encode!()
    |> World.clobber_from_string()

    :ok
  end

  test "get_entity/1" do
    assert World.get_entity("player12").id == "player12"
    assert is_nil(World.get_entity("bad id"))
  end

  test "entities_in_location/1" do
    assert [%{id: "player34"}] = World.entities_in_location("basement")
    assert [] = World.entities_in_location("nowhere")
  end

  test "entities_with_behavior/1" do
    assert [%{id: "plant"}] = World.entities_with_behavior(Doro.Behaviors.Visible)
    assert [] = World.entities_with_behavior(Doro.Behaviors.God)
  end

  test "entities_in_location_with_behavior/2" do
    assert [%{id: "player12"}] =
             World.entities_in_location_with_behavior("office", Doro.Behaviors.Player)

    assert [] = World.entities_in_location_with_behavior("nowhere", Doro.Behaviors.Player)
  end
end
