defmodule Doro.World.LoaderTest do
  use ExUnit.Case, async: true

  alias Doro.World.Loader
  alias Doro.Entity

  def make_world_file(sources) do
    %{sources: sources} |> Poison.encode!()
  end

  describe "load/1" do
    test "augments entities with the src attribute" do
      game_state =
        make_world_file(["priv_file://fixtures/loader_test_1.json"])
        |> Loader.load()

      assert %Entity{
               src: "priv_file://fixtures/loader_test_1.json"
             } = List.first(game_state.entities)
    end

    @tag :integration
    test "can load from a gist" do
      game_state =
        make_world_file(["gist://4575360d2bfb37998093fefe2f4aa44f"])
        |> Loader.load()

      entity =
        game_state.entities
        |> Enum.find(&(&1.id == "entity_from_gist"))

      assert %Entity{
               id: "entity_from_gist",
               name: "Entity from gist"
             } = entity
    end

    @tag :integration
    test "can load from a url" do
      game_state =
        make_world_file(["https://www.isnd.net/integration-tests/doro/entities.json"])
        |> Loader.load()

      entity =
        game_state.entities
        |> Enum.find(&(&1.id == "entity_from_url"))

      assert %Entity{
               id: "entity_from_url",
               name: "Entity from url"
             } = entity
    end
  end
end
