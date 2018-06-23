defmodule Doro.SentenceConstructionTest do
  use ExUnit.Case, async: true

  import Doro.SentenceConstruction
  alias Doro.Entity

  test "subject/2" do
    dusty = %Entity{name: "Dusty Cake"}
    aromatic = %Entity{name: "Aromatic Cake"}
    iceman = %Entity{name: "Iceman", behaviors: [Doro.Behaviors.Player]}

    assert definite(dusty) == "the Dusty Cake"
    assert indefinite(dusty) == "a Dusty Cake"

    assert definite(aromatic) == "the Aromatic Cake"
    assert indefinite(aromatic) == "an Aromatic Cake"

    assert definite(iceman) == "Iceman"
    assert indefinite(iceman) == "Iceman"
  end
end
