defmodule Doro.EntityTest do
  use ExUnit.Case, async: false

  alias Doro.Entity
  alias Doro.World
  alias Doro.Behaviors.Visible
  alias Doro.Behaviors.Portable
  alias Doro.Behaviors.Player
  alias Doro.Behaviors.God

  test "named?/2" do
    Doro.World.load_debug([%{id: "plant", name: "Fiddleleaf Fig"}])
    plant = World.get_entity("plant")

    assert Entity.named?(plant, "fig")
    assert Entity.named?(plant, "Fig")
    assert Entity.named?(plant, "fiddleleaf")
    assert Entity.named?(plant, "Fiddleleaf fig")
  end

  describe "behaviors/1" do
    test "returns an ordered list of all behaviors, up through the prototype chain" do
      Doro.World.load_debug([
        %{id: "foo", behaviors: ["visible"]},
        %{id: "bar", behaviors: ["portable", "player"], proto: "foo"},
        %{id: "baz", behaviors: ["god"], proto: "bar"},
        %{id: "instance", proto: "baz"}
      ])

      foo = World.get_entity("foo")
      bar = World.get_entity("bar")
      baz = World.get_entity("baz")
      instance = World.get_entity("instance")

      assert match?(%{Visible => _}, Entity.behaviors(foo))
      assert match?(%{Portable => _, Player => _, Visible => _}, Entity.behaviors(bar))
      assert match?(%{God => _, Portable => _, Player => _, Visible => _}, Entity.behaviors(baz))

      assert match?(
               %{God => _, Portable => _, Player => _, Visible => _},
               Entity.behaviors(instance)
             )
    end
  end

  describe "get_prop/2 and Access behavior getter" do
    setup do
      [
        %{
          id: "foo",
          props: %{
            data: :foo_data,
            data2: :data2_set_on_foo,
            data3: :data3_set_on_foo,
            data4: :data4_set_on_foo
          }
        },
        %{
          id: "bar",
          proto: "foo",
          props: %{data: :bar_data}
        },
        %{
          id: "baz",
          proto: "bar",
          props: %{data: :baz_data, data3: nil}
        },
        %{
          id: "instance",
          proto: "baz",
          props: %{data: :instance_data, data4: nil}
        }
      ]
      |> World.load_debug()

      ~w(foo bar baz instance)
      |> Enum.map(&{String.to_atom(&1), World.get_entity(&1)})
      |> Enum.into(%{})
    end

    test "returns the prop value set on an entity", %{foo: foo} do
      assert :foo_data = Entity.get_prop(foo, :data)
      assert :foo_data = foo[:data]
    end

    test "returns the prop value set on a prototype", %{instance: instance} do
      assert :data2_set_on_foo = Entity.get_prop(instance, :data2)
      assert :data2_set_on_foo = instance[:data2]
    end

    test "returns a nil value if it is set", %{foo: foo, instance: instance} do
      assert :data3_set_on_foo = Entity.get_prop(foo, :data3)
      assert :data3_set_on_foo = foo[:data3]

      assert is_nil(Entity.get_prop(instance, :data3))
      assert is_nil(instance[:data3])

      assert is_nil(Entity.get_prop(instance, :data4))
      assert is_nil(instance[:data4])
    end

    test "returns :error if key doesn't exist anywhere", %{instance: instance} do
      assert :error = Entity.get_prop(instance, :nonexistent)
    end
  end

  describe "set_prop/3" do
    test "sets the value on the instance, and returns the new value" do
      {"portable", entity} = Entity.set_prop(%Entity{}, "visible", "portable")
      assert "portable" = entity["visible"]
    end

    test "sets the value on the instance even when it exists on a prototype" do
      [%{id: "parent", props: %{data: 42}}, %{id: "child", proto: "parent"}]
      |> World.load_debug()

      [parent, entity] = ~w(parent child) |> Enum.map(&World.get_entity/1)

      assert {43, entity} = Entity.set_prop(entity, :data, entity[:data] + 1)
      assert 43 = entity[:data]
      assert 42 = parent[:data]
    end
  end
end
