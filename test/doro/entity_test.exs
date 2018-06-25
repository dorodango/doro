defmodule Doro.EntityTest do
  use ExUnit.Case, async: false

  alias Doro.Entity
  alias Doro.World

  test "named?/2" do
    plant =
      %Entity{
        id: "plant",
        name: "Fiddleleaf Fig",
        behaviors: ["visible", "portable", "vascular_plant"],
        props: %{
          location: "office",
          description: "is herbaceous, glabrous, and four-pinnate."
        }
      }
      |> Entity.preprocess_name()

    Doro.World.clobber(%{entities: [plant]})

    assert Entity.named?(plant, "fig")
    assert Entity.named?(plant, "Fig")
    assert Entity.named?(plant, "fiddleleaf")
    assert Entity.named?(plant, "Fiddleleaf fig")
  end

  describe "behaviors/1" do
    test "returns an ordered list of all behaviors, up through the prototype chain" do
      Doro.World.clobber(%{
        entities: [
          %Entity{id: "foo", behaviors: [:foo]},
          %Entity{id: "bar", behaviors: [:bar, :bar2], proto: "foo"},
          %Entity{id: "baz", behaviors: [:baz], proto: "bar"},
          %Entity{id: "instance", proto: "baz"}
        ]
      })

      foo = World.get_entity("foo")
      bar = World.get_entity("bar")
      baz = World.get_entity("baz")
      instance = World.get_entity("instance")

      assert [:foo] = Entity.behaviors(foo)
      assert [:bar, :bar2, :foo] = Entity.behaviors(bar)
      assert [:baz, :bar, :bar2, :foo] = Entity.behaviors(baz)
      assert [:baz, :bar, :bar2, :foo] = Entity.behaviors(instance)
    end
  end

  describe "get_prop/2 and Access behavior getter" do
    setup do
      foo = %Entity{
        id: "foo",
        props: %{
          data: :foo_data,
          data2: :data2_set_on_foo,
          data3: :data3_set_on_foo,
          data4: :data4_set_on_foo
        }
      }

      bar = %Entity{
        id: "bar",
        proto: "foo",
        props: %{data: :bar_data}
      }

      baz = %Entity{
        id: "baz",
        proto: "bar",
        props: %{data: :baz_data, data3: nil}
      }

      instance = %Entity{
        id: "instance",
        proto: "baz",
        props: %{data: :instance_data, data4: nil}
      }

      World.clobber(%{
        entities: [foo, bar, baz, instance]
      })

      %{foo: foo, bar: bar, baz: baz, instance: instance}
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
      {:bar, entity} = Entity.set_prop(%Entity{}, :foo, :bar)
      assert :bar = entity[:foo]
    end

    test "sets the value on the instance even when it exists on a prototype" do
      parent = %Entity{id: "parent", props: %{data: 42}}
      entity = %Entity{id: "child", proto: "parent"}
      World.clobber(%{entities: [parent, entity]})

      assert {43, entity} = Entity.set_prop(entity, :data, entity[:data] + 1)
      assert 43 = entity[:data]
      assert 42 = parent[:data]
    end
  end
end
