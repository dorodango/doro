defmodule Doro.World.GameStateTest do
  use ExUnit.Case, async: false

  alias Doro.World.GameState
  alias Doro.Entity

  setup do
    GameState.set(%{
      entities: [
        %Entity{
          id: "iceman",
          name: "Ice Man",
          props: %{location: "Below the hard deck"}
        },
        %Entity{
          id: "maverick",
          name: "Maverick",
          props: %{location: "Somewhere over the Indian Ocean"}
        }
      ]
    })

    :ok
  end

  describe "set/1" do
    test "clears the game state and sets the new one" do
      assert [%Entity{}, %Entity{}] = GameState.get_entities()

      GameState.set(%{entities: [%Entity{id: "2"}]})
      assert [%Entity{id: "2"}] = GameState.get_entities()
    end
  end

  describe "get_entity/1" do
    test "returns an entity with the given id, or nil" do
      assert %Entity{id: "iceman"} = GameState.get_entity("iceman")
      assert is_nil(GameState.get_entity(nil))
      assert is_nil(GameState.get_entity("unknown"))
    end
  end

  describe "get_entities/1" do
    test "returns all entities if no filter is passed" do
      entities = GameState.get_entities()
      assert length(entities) == 2
      assert Enum.any?(entities, &(&1.id == "iceman"))
      assert Enum.any?(entities, &(&1.id == "maverick"))
    end

    test "filters entities with filter function" do
      assert [%Entity{id: "maverick"}] =
               GameState.get_entities(&(&1[:location] == "Somewhere over the Indian Ocean"))
    end
  end

  describe "set_prop/3" do
    test "sets a property on the entity" do
      entity = %Entity{id: "id"}
      GameState.set(%{entities: [entity]})

      entity = GameState.set_prop("id", :location, "Berkeley")

      # sets it locally
      assert "Berkeley" == entity[:location]

      # sets it in ets
      assert "Berkeley" == GameState.get_entity("id")[:location]
    end
  end

  describe "add_entity/1" do
    test "inserts an entity into the game state" do
      refute GameState.get_entity("new_entity")
      GameState.add_entity(%Entity{id: "new_entity"})

      assert GameState.get_entity("new_entity")
    end
  end

  describe "add_entities/1" do
    test "inserts multiple entities into the game state" do
      refute GameState.get_entity("new_entity_1")
      refute GameState.get_entity("new_entity_2")

      GameState.add_entities([
        %Entity{id: "new_entity_1"},
        %Entity{id: "new_entity_2"}
      ])

      assert GameState.get_entity("new_entity_1")
      assert GameState.get_entity("new_entity_2")
    end
  end

  test "filters entities with filter function" do
    assert [%Entity{id: "maverick"}] =
             GameState.get_entities(&(&1[:location] == "Somewhere over the Indian Ocean"))
  end
end
