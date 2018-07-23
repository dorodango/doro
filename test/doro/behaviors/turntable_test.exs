defmodule Doro.Behaviors.TurntableTest do
  use ExUnit.Case, async: false

  describe "handle(%{verb: use})/3" do
    setup do
      Doro.World.load("priv_file://fixtures/turntable.json")

      %{
        turntable: Doro.World.get_entity("turntable"),
        player: Doro.World.get_entity("player")
      }
    end

    test "sets turntable playing true", %{turntable: turntable, player: player} do
      Doro.Behaviors.Turntable.handle("use", %{object: turntable, player: player})
      turntable = Doro.World.get_entity("turntable")
      assert turntable[:playing]
    end

    test "updates the turntable description to show it's playing true", %{
      turntable: turntable,
      player: player
    } do
      Doro.Behaviors.Turntable.handle("use", %{object: turntable, player: player})
      turntable = Doro.World.get_entity("turntable")
      assert ~r{33RPM} |> Regex.match?(turntable[:description])
    end
  end

  describe "handle(%{verb: stop})/3" do
    setup do
      Doro.World.load("priv_file://fixtures/turntable.json")
      Doro.World.get_entity("turntable") |> Doro.World.set_prop(:playing, true)

      %{
        turntable: Doro.World.get_entity("turntable"),
        player: Doro.World.get_entity("player")
      }
    end

    test "sets turntable playing false", %{turntable: turntable, player: player} do
      Doro.Behaviors.Turntable.handle("stop", %{object: turntable, player: player})
      turntable = Doro.World.get_entity("turntable")
      refute turntable[:playing]
    end

    test "updates the turntable description to show it's playing true", %{
      turntable: turntable,
      player: player
    } do
      Doro.Behaviors.Turntable.handle("stop", %{object: turntable, player: player})
      turntable = Doro.World.get_entity("turntable")
      refute ~r{33RPM} |> Regex.match?(turntable[:description])
    end
  end
end
