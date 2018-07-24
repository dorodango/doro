defmodule Doro.SentenceConstructionTest do
  use ExUnit.Case, async: true

  import Doro.SentenceConstruction

  setup do
    [
      %{id: "dusty", name: "Dusty Cake"},
      %{id: "aromatic", name: "Aromatic Cake"},
      %{id: "iceman", name: "Iceman", behaviors: ["player"]}
    ]
    |> Doro.World.load_debug()

    ~w(dusty aromatic iceman)
    |> Enum.map(&{String.to_atom(&1), Doro.World.get_entity(&1)})
    |> Enum.into(%{})
  end

  describe("definite/1") do
    test "returns names with definite articles unless it's a person", %{
      dusty: dusty,
      aromatic: aromatic,
      iceman: iceman
    } do
      assert definite(dusty) == "the Dusty Cake"
      assert definite(aromatic) == "the Aromatic Cake"
      assert definite(iceman) == "Iceman"
    end
  end

  describe("indefinite/1") do
    test "returns names with indefinite articles unless it's a person", %{
      dusty: dusty,
      aromatic: aromatic,
      iceman: iceman
    } do
      assert indefinite(dusty) == "a Dusty Cake"
      assert indefinite(aromatic) == "an Aromatic Cake"
      assert indefinite(iceman) == "Iceman"
    end
  end

  describe "indefinite_list/2" do
    test "returns a comma-separated list of indefinite entities with a conjunction", %{
      dusty: dusty,
      aromatic: aromatic,
      iceman: iceman
    } do
      assert indefinite_list([dusty, iceman, aromatic], "and") ==
               "a Dusty Cake, Iceman and an Aromatic Cake"

      assert indefinite_list([dusty, iceman], "or") == "a Dusty Cake or Iceman"
      assert indefinite_list([aromatic], "or") == "an Aromatic Cake"
      assert indefinite_list([]) == "nothing"
    end
  end

  describe "definite_list/2" do
    test "returns a comma-separated list of definite entities with a conjunction", %{
      dusty: dusty,
      aromatic: aromatic,
      iceman: iceman
    } do
      assert definite_list([dusty, iceman, aromatic], "or") ==
               "the Dusty Cake, Iceman or the Aromatic Cake"

      assert definite_list([dusty, iceman], "and") == "the Dusty Cake and Iceman"
      assert definite_list([aromatic], "or") == "the Aromatic Cake"
      assert indefinite_list([]) == "nothing"
    end
  end
end
