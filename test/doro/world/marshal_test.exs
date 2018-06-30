defmodule Doro.World.MarshalTest do
  use ExUnit.Case, async: true

  alias Doro.World.Marshal

  describe "marshal/1" do
    setup do
      read_fixture("world.json") |> Doro.World.clobber()

      %{
        marshalled: %{"entities" => Doro.World.GameState.get() |> Marshal.marshal()}
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

  describe "unmarshal/1" do
    setup do
      %{game_state: Marshal.unmarshal(read_fixture("world.json"))}
    end

    test "transforms JSON into a usable game state", %{game_state: %{entities: entities}} do
      assert 5 = length(entities)

      player_proto = entities |> Enum.find(&(&1.id == "_player"))
      assert [Doro.Behaviors.Visible, Doro.Behaviors.Player] = Doro.Entity.behaviors(player_proto)
    end
  end

  defp find_entity_by_id(entities, id) do
    entities |> Enum.find(fn entity -> entity |> Map.get(:id) == id end)
  end

  defp read_fixture(filename) do
    "fixtures/#{filename}"
    |> Path.expand(Application.app_dir(:doro, "priv"))
    |> File.read!()
  end
end
