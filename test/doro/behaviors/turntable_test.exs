defmodule Doro.Behaviors.TurntableTest do
  use ExUnit.Case, async: false

  import Doro.TestFixtures

  describe "handle(%{verb: use})/3" do
    setup do
      read_fixture("turntable.json") |> Doro.World.clobber()
      Doro.World.GameState.get() |> Doro.World.Marshal.marshal()

      %{
        turntable: Doro.World.get_entity("turntable"),
        player: Doro.World.get_entity("player")
      }
    end

    test "sets turntable playing true", %{turntable: turntable, player: player} do
      Doro.Behaviors.Turntable.handle(%{verb: "use", object: turntable, player: player})
      turntable = Doro.World.get_entity("turntable")
      assert turntable[:playing]
    end

    test "updates the turntable description to show it's playing true", %{
      turntable: turntable,
      player: player
    } do
      Doro.Behaviors.Turntable.handle(%{verb: "use", object: turntable, player: player})
      turntable = Doro.World.get_entity("turntable")
      assert ~r{33RPM} |> Regex.match?(turntable[:description])
    end
  end

  describe "handle(%{verb: stop})/3" do
    setup do
      read_fixture("turntable.json") |> Doro.World.clobber()
      Doro.World.GameState.get() |> Doro.World.Marshal.marshal()
      Doro.World.get_entity("turntable") |> Doro.World.set_prop(:playing, true)

      %{
        turntable: Doro.World.get_entity("turntable"),
        player: Doro.World.get_entity("player")
      }
    end

    test "sets turntable playing false", %{turntable: turntable, player: player} do
      Doro.Behaviors.Turntable.handle(%{verb: "stop", object: turntable, player: player})
      turntable = Doro.World.get_entity("turntable")
      refute turntable[:playing]
    end

    test "updates the turntable description to show it's playing true", %{
      turntable: turntable,
      player: player
    } do
      Doro.Behaviors.Turntable.handle(%{verb: "stop", object: turntable, player: player})
      turntable = Doro.World.get_entity("turntable")
      refute ~r{33RPM} |> Regex.match?(turntable[:description])
    end
  end
end
