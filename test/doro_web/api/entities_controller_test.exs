defmodule DoroWeb.Api.UserControllerTest do
  use DoroWeb.ConnCase, async: false

  describe "&create/2" do
    setup do
      Doro.World.load_debug([])
      %{params: %{id: "tomcat"}}
    end

    test "&create/2 creates a new entity in the game state with just an id", %{
      conn: conn,
      params: params
    } do
      response =
        conn
        |> put("/api/entities", params)
        |> json_response(200)

      assert response == %{"message" => "created entity: tomcat"}

      expected_entity = %Doro.Entity{
        behaviors: [Doro.Behaviors.Visible],
        id: "tomcat",
        name: "tomcat",
        name_tokens: MapSet.new(["tomcat"]),
        props: %{},
        proto: nil
      }

      assert Doro.World.get_entity("tomcat") == expected_entity
    end

    test "&create/2 creates a new entity with specified behaviors", %{
      conn: conn,
      params: params
    } do
      extra_params = %{
        behaviors: ["this", "turntable"]
      }

      conn
      |> put("/api/entities", params |> Map.merge(extra_params))
      |> json_response(200)

      expected_entity = %Doro.Entity{
        behaviors: [Doro.Behaviors.Visible, Doro.Behaviors.Turntable],
        id: "tomcat",
        name: "tomcat",
        name_tokens: MapSet.new(["tomcat"]),
        props: %{},
        proto: nil
      }

      assert Doro.World.get_entity("tomcat") == expected_entity
    end

    test "&create/2 creates a new entity with the right props", %{
      conn: conn,
      params: params
    } do
      extra_params = %{
        name: "the tomcat",
        behaviors: nil,
        props: %{location: "room", description: "this is the description"}
      }

      conn
      |> put("/api/entities", params |> Map.merge(extra_params))
      |> json_response(200)

      entity = Doro.World.get_entity("tomcat")
      assert entity.id == "tomcat"
      assert entity.name == "the tomcat"
      assert entity.name_tokens == MapSet.new(["the", "tomcat", "the tomcat"])
      assert entity[:location] == "room"
      assert entity.behaviors |> Enum.member?(Doro.Behaviors.Visible)
    end
  end

  describe "&update/2" do
    setup do
      Doro.World.load("priv_file://fixtures/turntable.json")
      %{params: %{id: "turntable", behaviors: ["visible", "slot_machine"]}}
    end

    test "&update/2 updates the entity with the new properties", %{
      conn: conn,
      params: params
    } do
      response =
        conn
        |> post("/api/entities/#{params[:id]}", %{
          props: %{description: "whatever", playing: true}
        })
        |> json_response(200)

      assert response == %{"message" => "updated entity turntable"}

      updated = Doro.World.get_entity("turntable")
      assert updated[:playing]
    end

    test "&update/2 updates the name and name tokens", %{
      conn: conn,
      params: params
    } do
      conn
      |> post("/api/entities/#{params[:id]}", %{
        name: "this name",
        props: %{location: "somewhere"}
      })
      |> json_response(200)

      updated = Doro.World.get_entity("turntable")
      assert updated.name == "this name"
      assert updated.name_tokens == MapSet.new(["this", "name", "this name"])
      assert updated[:location] == "somewhere"
    end

    test "&update/2 updates behaviors by clobbering old behavior list with the new list", %{
      conn: conn,
      params: params
    } do
      original = Doro.World.get_entity("turntable")
      assert original.behaviors |> Enum.member?(Doro.Behaviors.Visible)
      assert original.behaviors |> Enum.member?(Doro.Behaviors.Turntable)

      conn
      |> post("/api/entities/#{params[:id]}", %{
        behaviors: ["god"]
      })
      |> json_response(200)

      updated = Doro.World.get_entity("turntable")
      assert updated.behaviors == [Doro.Behaviors.God]
    end
  end
end
