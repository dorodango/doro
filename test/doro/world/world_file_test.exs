defmodule Doro.World.WorldFileTest do
  use ExUnit.Case, async: true

  alias Doro.World.WorldFile

  describe "load_source/1" do
    test "loads from a local file" do
      entities = WorldFile.load_source("priv_file://fixtures/loader_test_1.json")
      first = Enum.find(entities, &(&1.id == "loader-test-entity"))
      second = Enum.find(entities, &(&1.id == "loader-test-entity-2-1"))

      assert length(entities) == 3

      assert match?(
               %{
                 id: "loader-test-entity",
                 src: "priv_file://fixtures/loader_test_1.json"
               },
               first
             )

      assert match?(
               %{
                 id: "loader-test-entity-2-1",
                 src: "priv_file://fixtures/loader_test_2.json"
               },
               second
             )
    end

    @tag :integration
    test "loads from gists" do
      [first | [second | _]] = WorldFile.load_source("gist://4575360d2bfb37998093fefe2f4aa44f")

      assert match?(
               %{
                 id: "entity_from_gist",
                 src: "gist://4575360d2bfb37998093fefe2f4aa44f"
               },
               first
             )

      assert match?(
               %{
                 id: "entity_from_gist_2",
                 src: "gist://f1dd142790a718999b0731e3676fc372"
               },
               second
             )

      assert first.id == "entity_from_gist"
      assert second.id == "entity_from_gist_2"
    end

    @tag :integration
    test "loads from urls" do
      [first | [second | _]] =
        WorldFile.load_source("https://www.isnd.net/integration-tests/doro/entities.json")

      assert match?(
               %{
                 id: "entity_from_url",
                 src: "https://www.isnd.net/integration-tests/doro/entities.json"
               },
               first
             )

      assert match?(
               %{
                 id: "entity_from_url_2",
                 src: "https://www.isnd.net/integration-tests/doro/entities2.json"
               },
               second
             )
    end
  end
end
