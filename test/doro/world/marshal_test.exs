defmodule Doro.World.MarshalTest do
  use ExUnit.Case, async: true

  alias Doro.World.Marshal

  describe "marshal/1" do
    setup do
      Doro.World.load("priv_file://fixtures/world.json")

      %{
        marshalled: %{"entities" => Doro.World.get_entities() |> Marshal.marshal()}
      }
    end

    test "transforms the game state with canonical behaviors", %{
      marshalled: %{"entities" => marshalled}
    } do
      ice = marshalled |> find_entity_by_id("ice")
      assert ice |> Map.get(:behaviors) == []
      player = marshalled |> find_entity_by_id("_player")
      assert player |> Map.get(:behaviors) == ["visible", "player"]
      god = marshalled |> find_entity_by_id("_god")
      assert god |> Map.get(:behaviors) == ["god"]
    end

    test "generate name_tokens as needed", %{marshalled: %{"entities" => marshalled}} do
      ice = marshalled |> find_entity_by_id("ice")
      assert ice |> Map.get(:name_tokens) == MapSet.new(~w[iceman])
      player = marshalled |> find_entity_by_id("_player")

      assert player |> Map.get(:name_tokens) ==
               MapSet.new(["player", "prototype", "player prototype"])

      tomcat = marshalled |> find_entity_by_id("tomcat")
      assert tomcat |> Map.get(:name_tokens) == MapSet.new(["f14", "tomcat", "f14 tomcat"])
    end
  end

  describe "unmarshal_entity/1" do
    test "transforms an entity spec into an Entity ready to be added to the world" do
      entity_spec = %{
        id: "_player",
        name: "Player prototype",
        behaviors: ["visible", "player"],
        props: %{
          description: "is player prototype.  Put some props on the instance!"
        }
      }

      %Doro.Entity{} = entity = Marshal.unmarshal_entity(entity_spec)
      assert entity.behaviors == [Doro.Behaviors.Visible, Doro.Behaviors.Player]

      assert MapSet.equal?(
               entity.name_tokens,
               MapSet.new(["player", "prototype", "player prototype"])
             )
    end
  end

  defp find_entity_by_id(entities, id) do
    entities |> Enum.find(fn entity -> entity |> Map.get(:id) == id end)
  end
end
