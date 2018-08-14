defmodule Doro.World.EntityManagementTest do
  use ExUnit.Case, async: false

  alias Doro.World
  alias Doro.World.EntityManagement
  alias Doro.Entity

  setup do
    {
      :ok,
      %{
        entity_specs: Doro.World.WorldFile.load_source("priv_file://fixtures/world.json")
      }
    }
  end

  describe "reset/1" do
    test "clears the game state and sets the new one", %{entity_specs: entity_specs} do
      World.load_debug([%{id: "old_entity"}])

      assert match?(
               %{id: "old_entity"},
               World.get_entity("old_entity")
             )

      EntityManagement.reset(entity_specs)

      assert is_nil(World.get_entity("old_entity"))
      assert World.get_entity("ice")
    end
  end

  describe "add_entity/1" do
    test "rolls up behaviors and adds the entity to gamestate", %{entity_specs: entity_specs} do
      World.load_debug([%{id: "old_entity"}])

      assert match?(
               %{id: "old_entity"},
               World.get_entity("old_entity")
             )

      EntityManagement.reset(entity_specs)

      assert is_nil(World.get_entity("old_entity"))
      assert World.get_entity("ice")
    end
  end
end
