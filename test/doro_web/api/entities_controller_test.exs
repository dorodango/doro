defmodule DoroWeb.Api.UserControllerTest do
  use DoroWeb.ConnCase, async: false

  alias Doro.Entity

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

      assert match?(
               %Entity{
                 behaviors: %{Doro.Behaviors.Visible => _},
                 id: "tomcat",
                 name: "tomcat",
                 props: %{},
                 proto: nil
               },
               Doro.World.get_entity("tomcat")
             )
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

      assert match?(
               %Entity{
                 behaviors: %{Doro.Behaviors.Visible => _, Doro.Behaviors.Turntable => _},
                 id: "tomcat",
                 name: "tomcat",
                 props: %{},
                 proto: nil
               },
               Doro.World.get_entity("tomcat")
             )
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
      assert Entity.has_behavior?(entity, Doro.Behaviors.Visible)
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
      assert Entity.has_behavior?(original, Doro.Behaviors.Visible)
      assert Entity.has_behavior?(original, Doro.Behaviors.Turntable)

      conn
      |> post("/api/entities/#{params[:id]}", %{
        behaviors: ["god"]
      })
      |> json_response(200)

      updated = Doro.World.get_entity("turntable")
      assert Entity.has_behavior?(updated, Doro.Behaviors.God)
    end
  end
end
