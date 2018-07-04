defmodule Doro.WorldTest do
  use ExUnit.Case, async: true

  alias Doro.World
  import Doro.World.EntityFilters

  setup do
    %{
      entities: [
        %{id: "start"},
        %{id: "basement"},
        %{id: "player12", name: "John Foo", behaviors: ["player"], props: %{location: "start"}},
        %{id: "player34", name: "Foo Bar", behaviors: ["player"], props: %{location: "basement"}},
        %{id: "plant", behaviors: ["visible"], props: %{location: "start"}}
      ]
    }
    |> Poison.encode!()
    |> World.clobber()

    :ok
  end

  test "get_entity/1" do
    assert World.get_entity("player12").id == "player12"
    assert is_nil(World.get_entity("bad id"))
  end

  test "in_location filter" do
    assert [%{id: "player34"}] = World.get_entities([in_location("basement")])
    assert [] = World.get_entities([in_location("nowhere")])
  end

  test "in_locations filter" do
    entities = World.get_entities([in_locations(~w(start basement))])
    assert length(entities) == 3
  end

  test "has_behavior filter" do
    assert [%{id: "plant"}] = World.get_entities([has_behavior(Doro.Behaviors.Visible)])
    assert [] = World.get_entities([has_behavior(Doro.Behaviors.God)])
  end

  test "except filter" do
    assert [%{id: "plant"}] =
             World.get_entities([
               in_location("start"),
               except("player12")
             ])
  end

  test "named filter" do
    assert [%{id: "player34"}] = World.get_entities([named("bar")])
    assert [] = World.get_entities([named(nil)])

    foos = World.get_entities([named("foo")])
    assert length(foos) == 2
  end

  test "multiple filters" do
    assert [%{id: "player12"}] =
             World.get_entities([
               in_location("start"),
               player()
             ])

    assert [] =
             World.get_entities([
               in_location("nowhere"),
               player()
             ])
  end
end
