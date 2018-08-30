defmodule DoroWeb.Api.UserControllerTest do
  use DoroWeb.ConnCase, async: false

  alias Doro.Entity

  describe "&create/2" do
    setup do
      Doro.World.load_debug([])
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

      entity = Doro.World.get_entity("new-thing")
      assert entity.id == "new-thing"
      assert entity.name == "new thing"
      assert entity.name_tokens == MapSet.new(["new", "thing", "new thing"])
      assert entity[:location] == "closet"
      assert Entity.has_behavior?(entity, Doro.Behaviors.Visible)
      visible_behavior = entity |> Map.get(:behaviors) |> Map.get(Doro.Behaviors.Visible)
      assert Map.get(visible_behavior, :description) == "the description"
      exit_behavior = entity |> Map.get(:behaviors) |> Map.get(Doro.Behaviors.Exit)
      assert Map.get(exit_behavior, :destination_id) == "fire_escape"
    end
  end

  describe "&update/2" do
    setup do
      Doro.World.load("priv_file://fixtures/turntable.json")
      %{ path: "/api/entities/turntable" }
    end

    test "updates the entity with the new properties", %{
      conn: conn,
      path: path
    } do
      response =
        conn
        |> post(path, %{
            id: "turntable",
            props: %{playing: true},
            behaviors: [
              %{
                 "type" => "exit",
                 "destination_id" => "fire_escape"
              },
              %{
                "type" => "visible",
                "description" => "shiny new description"
              }
            ]
          }
        )
        |> json_response(200)

      assert response == %{"message" => "updated entity turntable"}

      turntable = Doro.World.get_entity("turntable")
      assert turntable[:playing]
      desc = (turntable |> Map.get(:behaviors) |> Map.get(Doro.Behaviors.Visible) |> Map.get(:description))
      assert desc == "shiny new description"
    end

    test "updates the name and name tokens", %{
      conn: conn,
      path: path
    } do
      conn
      |> post(path, %{
        name: "this name",
        props: %{location: "somewhere"}
      })
      |> json_response(200)

      updated = Doro.World.get_entity("turntable")
      assert updated.name == "this name"
      assert updated.name_tokens == MapSet.new(["this", "name", "this name"])
      assert updated[:location] == "somewhere"
    end

    test "updates behaviors by clobbering old behavior list with the new list", %{
      conn: conn,
      path: path
    } do
      original = Doro.World.get_entity("turntable")
      assert Entity.has_behavior?(original, Doro.Behaviors.Visible)
      assert Entity.has_behavior?(original, Doro.Behaviors.Turntable)

      conn
      |> post(path, %{
        name: "new turntable",
        behaviors: [
          %{"type" => "god"}
        ]
      })
      |> json_response(200)

      updated = Doro.World.get_entity("turntable")
      assert Entity.has_behavior?(updated, Doro.Behaviors.God)
      refute Entity.has_behavior?(updated, Doro.Behaviors.Turntable)
      refute Entity.has_behavior?(updated, Doro.Behaviors.Visible)
    end
  end
end
