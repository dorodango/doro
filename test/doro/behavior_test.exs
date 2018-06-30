defmodule Doro.BehaviorTest do
  use ExUnit.Case, async: true

  describe "&find/1" do
    test "finds behavoirs by string if they exist" do
      assert Doro.Behavior.find("visible") == Doro.Behaviors.Visible
      assert Doro.Behavior.find("god") == Doro.Behaviors.God
    end

    test "returns nil for behaviors we don't know about" do
      assert Doro.Behavior.find("totally_unknown_behavior") == nil
    end

    test "returns nil for nil" do
      assert Doro.Behavior.find(nil) == nil
    end

    test "returns nil for empty string" do
      assert Doro.Behavior.find("") == nil
    end
  end
end
