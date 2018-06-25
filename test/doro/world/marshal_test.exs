defmodule Doro.World.MarshalTest do
  use ExUnit.Case, async: true

  alias Doro.World.Marshal

  describe "unmarshal/1" do
    setup do
      %{game_state: Marshal.unmarshal(read_fixture("world.json"))}
    end

    test "transforms JSON into a usable game state", %{game_state: %{entities: entities}} do
      assert 5 = length(entities)

      player_proto = entities |> Enum.find(&(&1.id == "_player"))
      assert [Doro.Behaviors.Visible, Doro.Behaviors.Player] = Doro.Entity.behaviors(player_proto)
    end
  end

  defp read_fixture(filename) do
    "fixtures/#{filename}"
    |> Path.expand(Application.app_dir(:doro, "priv"))
    |> File.read!()
  end
end
