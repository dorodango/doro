defmodule DoroWeb.Api.EntitiesControllerTest do
  use DoroWeb.ConnCase, async: false

  alias Doro.Entity
  alias Doro.World

  describe "&create/2" do
    setup do
      World.load_debug([%{id: "old_thing", name: "the old thing"}])
      {:ok, :ok}
    end

    test "creates a new entity with the right props", %{
      conn: conn
    } do
      params = %{
        "behaviors" => [
          %{ "type" => "exit", "destination_id" => "fire_escape"},
          %{ "type" => "visible", "description" => "the description"}
        ],
        "id" => "new-thing",
        "name" => "new thing",
        "props" => %{"location" => "closet"}
      }

      conn
      |> put("/api/entities", params)
      |> json_response(200)

      assert length(World.get_entities()) == 2

      entity = World.get_entity("new-thing")
      assert entity.id == "new-thing"
      assert entity.name == "new thing"
      assert entity.name_tokens == MapSet.new(["new", "thing", "new thing"])
      assert entity.src == nil
      assert entity[:location] == "closet"
      assert Entity.has_behavior?(entity, Doro.Behaviors.Visible)
      visible_behavior = entity |> Map.get(:behaviors) |> Map.get(Doro.Behaviors.Visible)
      assert Map.get(visible_behavior, :description) == "the description"
      exit_behavior = entity |> Map.get(:behaviors) |> Map.get(Doro.Behaviors.Exit)
      assert Map.get(exit_behavior, :destination_id) == "fire_escape"
    end

    test "clobbers existing entities with the same id", %{
      conn: conn
    } do
      params = %{
        "id" => "old_thing",
        "name" => "clobbered new old thing"
      }

      conn
      |> put("/api/entities", params)
      |> json_response(200)

      assert length(World.get_entities()) == 1
      entity = World.get_entity("old_thing")
      assert entity.id == "old_thing"
      assert entity.name == "clobbered new old thing"
      assert entity.src == nil
      assert entity.behaviors == %{}
    end
  end

end
