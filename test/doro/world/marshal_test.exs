defmodule Doro.World.MarshalTest do
  use ExUnit.Case, async: true

  alias Doro.World.Marshal
  alias Doro.Behaviors.Visible
  alias Doro.Behaviors.Player

  describe "marshal/1" do
    setup do
      Doro.World.load("priv_file://fixtures/world.json")

      %{
        marshalled: %{"entities" => Doro.World.get_entities() |> Marshal.marshal()}
      }
    end

    test "transforms the game state prototypes and behaviors", %{
      marshalled: %{"entities" => marshalled}
    } do
      ice = marshalled |> find_entity_by_id("ice")
      assert ice |> Map.get(:behaviors) == []
      assert ice |> Map.get(:proto) == "_god"

      maverick = marshalled |> find_entity_by_id("mav")
      assert maverick |> Map.get(:behaviors) == []
      assert maverick |> Map.get(:proto) == "_player"

      bathroom = marshalled |> find_entity_by_id("bathroom")
      assert MapSet.equal?(
        MapSet.new(bathroom.behaviors),
        MapSet.new([
          %{
            __struct__: Doro.Behaviors.Visible,
            own: true,
            type: "visible",
            description: "a dingy bathroom"
          }
        ])
      )
    end

    test "generate name_tokens as needed", %{marshalled: %{"entities" => marshalled}} do
      ice = marshalled |> find_entity_by_id("ice")
      assert ice |> Map.get(:name_tokens) == MapSet.new(~w[iceman])
      player = marshalled |> find_entity_by_id("mav")

      assert player |> Map.get(:name_tokens) == MapSet.new(["mav", "e", "rick", "mav e rick"])
    end
  end

  describe "unmarshal_entity/1" do
    test "transforms an entity spec into an Entity ready to be added to the world" do
      entity =
        %{
          id: "_player",
          name: "Player prototype",
          behaviors: ["visible", "player"],
          props: %{
            description: "is player prototype.  Put some props on the instance!"
          }
        }
        |> Marshal.unmarshal_entity()

      %Doro.Entity{behaviors: behaviors, name_tokens: name_tokens} = entity

      assert match?(
               %{Doro.Behaviors.Player => %Player{}, Doro.Behaviors.Visible => %Visible{}},
               behaviors
             )

      assert MapSet.equal?(
               name_tokens,
               MapSet.new(["player", "prototype", "player prototype"])
             )
    end
  end

  defp find_entity_by_id(entities, id) do
    entities |> Enum.find(fn entity -> entity |> Map.get(:id) == id end)
  end
end
